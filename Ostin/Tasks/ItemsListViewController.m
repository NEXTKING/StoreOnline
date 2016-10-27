//
//  ItemsListViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 22/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ItemsListViewController.h"
#import "MCPServer.h"
#import "ItemsListCell.h"
#import "OstinViewController.h"
#import "TasksNavigationController.h"
#import "TaskProgressOverlayController.h"
#import "BarcodeFormatter.h"
#import "PrintViewController.h"
#import "ZPLGenerator.h"
#import "AsyncImageView.h"

@interface ItemsListViewController () <ItemDescriptionDelegate, PrinterControllerDelegate>
{
    NSMutableArray *_items;
    UIActivityIndicatorView *_activityIndicator;
    PrintViewController *_printVC;
    ItemInformation *_itemInPrintQueue;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;

@end

@implementation ItemsListViewController

static NSString * const reuseIdentifier = @"AllItemsIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    _items = [[NSMutableArray alloc] init];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemsListCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self requestData];
    [self updateNotificationStatus];
    [self updateActionButton];
    [self updateOverlayInfo];
    
    if (_tasksMode)
        [self initializePrintViewController];
}

- (void)updateOverlayInfo
{
    if (_task != nil)
    {
        TasksNavigationController *navVC = (TasksNavigationController *)self.navigationController;
        BOOL timerIsRunning = _task.status == TaskInformationStatusInProgress;
        __block NSInteger totalCount = 0;
        __block NSInteger completeCount = 0;
        
        [_task.items enumerateObjectsUsingBlock:^(TaskItemInformation *item, NSUInteger idx, BOOL *stop) {
            totalCount += item.quantity;
            completeCount += item.scanned;
        }];
        
        [navVC.overlayController setTitleText:_task.name startDate:_task.startDate endDate:_task.endDate totalItemsCount:totalCount completeItemsCount:completeCount timerIsRunning:timerIsRunning];
    }
}

- (void)updateActionButton
{
    if (!_tasksMode)
    {
        self.actionButton.title = @"";
        self.actionButton.enabled = YES;
    }
    else
    {
        if (_task.status == TaskInformationStatusNotStarted)
        {
            self.actionButton.title = @"Начать";
            self.actionButton.enabled = YES;
        }
        else if (_task.status == TaskInformationStatusInProgress)
        {
            self.actionButton.title = @"Завершить";
            self.actionButton.enabled = YES;
        }
        else if (_task.status == TaskInformationStatusComplete)
        {
            self.actionButton.title = @"Завершено";
            self.actionButton.enabled = NO;
        }
    }
}

- (void)updateNotificationStatus
{
    if (_tasksMode)
    {
        if (_task.status == TaskInformationStatusNotStarted)
        {
            
        }
        else if (_task.status == TaskInformationStatusInProgress)
        {
            [self subscribeToScanNotifications];
        }
        else if (_task.status == TaskInformationStatusComplete)
        {
            [self unsubscribeFromScanNotifications];
        }
    }
}

- (void)initializePrintViewController
{
    if (_printVC == nil)
    {
        _printVC = [PrintViewController new];
        _printVC.delegate = self;
        
        [self.view addSubview:_printVC.view];
        _printVC.view.hidden = YES;
    }
}

- (void)dealloc
{
    [self unsubscribeFromScanNotifications];
}

- (void)showLoadingIndicator
{
    if (_activityIndicator == nil)
    {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0, 0, 40, 40);
        _activityIndicator.center = self.tableView.center;
    }
    
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    [self.tableView setScrollEnabled:NO];
}

- (void)hideLoadingIndicator
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    [self.tableView setScrollEnabled:YES];
}

- (void)showAlertWithMessage:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark Notifications

- (void)subscribeToScanNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveScanNotification:) name:@"BarcodeScanNotification" object:nil];
}

- (void)unsubscribeFromScanNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BarcodeScanNotification" object:nil];
}

- (void)didReceiveScanNotification:(NSNotification *)notification
{
    NSString *barcode = notification.object[@"barcode"];
    NSNumber *type = notification.object[@"type"];
    
    NSString *internalBarcode = [BarcodeFormatter normalizedBarcodeFromString:barcode isoType:type.intValue];
    [self itemDidScannedWithBarcode:internalBarcode];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.itemImageView.image = [UIImage imageNamed:@"no-image.png"];
    
    if (_tasksMode)
    {
        TaskItemInformation *taskItemInfo = _task.items[indexPath.row];
        ItemInformation *item = [self itemInfoForTaskItemWithID:taskItemInfo.itemID];
        
        cell.articleLabel.text = item != nil ? item.article : @"";
        cell.nameLabel.text = item != nil ? item.name : @"";
        cell.barcodeLabel.text = item != nil ? [NSString stringWithFormat:@"Штрих-код: %@", item.barcode] : @"";
        
        cell.quantityLabel.hidden = NO;
        cell.quantityLabel.text = [NSString stringWithFormat:@"Количество: %ld из %ld", taskItemInfo.scanned, taskItemInfo.quantity];
        UIColor *greenColor = [UIColor colorWithRed:215/255.0 green:1.0 blue:215/255.0 alpha:1.0];
        UIColor *whiteColor = [UIColor whiteColor];
        cell.backgroundColor = (taskItemInfo.scanned == taskItemInfo.quantity) && taskItemInfo.quantity != 0 ? greenColor : whiteColor;
        
        NSString *urlString = [item additionalParameterValueForName:@"imageURL"];
        if (urlString != nil)
            cell.itemImageView.imageURL = [NSURL URLWithString:urlString];
    }
    else
    {
        ItemInformation *item = _items[indexPath.row];
        
        cell.articleLabel.text = item.article;
        cell.nameLabel.text = item.name;
        cell.barcodeLabel.text = item.barcode;
        
        cell.quantityLabel.hidden = YES;
        cell.backgroundColor = [UIColor whiteColor];
        
        NSString *urlString = [item additionalParameterValueForName:@"imageURL"];
        if (urlString != nil)
            cell.itemImageView.imageURL = [NSURL URLWithString:urlString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsListCell *_cell = (ItemsListCell *)cell;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_cell.itemImageView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailDescriptionSegue" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailDescriptionSegue"])
    {
        OstinViewController* ostinVC = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        
        ItemInformation* itemInfo = _items[indexPath.row];
        ostinVC.currentItemInfo = itemInfo;
    }
}


#pragma mark Network Delegate

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result == 0)
        {
            [_items addObject:itemDescription];
            NSUInteger index = [_items indexOfObject:itemDescription];
            [wself.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            
        }
    });
}

- (void) allItemsDescription:(int)result items:(NSArray<ItemInformation *> *)items
{
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result == 0)
        {
            [_items removeAllObjects];
            [_items addObjectsFromArray:items];
            [wself.tableView reloadData];
        }
        else
        {
            
        }
    });
}

#pragma mark Core logic

- (void)requestData
{
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_tasksMode)
        {
            for (TaskItemInformation *taskItemInformation in _task.items)
                [[MCPServer instance] itemDescription:wself itemID:taskItemInformation.itemID];
        }
        else
            [[MCPServer instance] itemDescription:wself itemCode:nil shopCode:nil isoType:0];
    });
}

- (void)itemDidScannedWithBarcode:(NSString *)barcode
{
    if (_itemInPrintQueue == nil)
    {
        ItemInformation *item;
        
        for (ItemInformation *itemInfo in _items)
            if ([itemInfo.barcode isEqualToString:barcode])
            {
                item = itemInfo;
                break;
            }
        
        if (item != nil)
        {
            TaskItemInformation *taskItemInfo = [self taskItemInfoForItemWithID:item.itemId];
            if (taskItemInfo.scanned + 1 <= taskItemInfo.quantity)
            {
                _itemInPrintQueue = item;
                [self printItem:item];
            }
        }
    }
}

- (IBAction)actionButtonPressed:(id)sender
{
    if (_tasksMode)
    {
        NSDate *now = [NSDate date];
        TaskInformationStatus nextStatus;
        
        if (_task.status == TaskInformationStatusNotStarted)
            nextStatus = TaskInformationStatusInProgress;
        else if (_task.status == TaskInformationStatusInProgress)
            nextStatus = TaskInformationStatusComplete;
        
        [self showLoadingIndicator];
        
        __weak typeof(self) wself = self;
        [[MCPServer instance] saveTaskWithID:_task.taskID userID:_task.userID status:nextStatus date:now completion:^(BOOL success, NSString *errorMessage) {
            
            [self hideLoadingIndicator];
            if (success)
            {
                if (wself.task.status == TaskInformationStatusNotStarted)
                    wself.task.startDate = now;
                else if (wself.task.status == TaskInformationStatusInProgress)
                    wself.task.endDate = now;
                    
                wself.task.status = nextStatus;
                [wself updateNotificationStatus];
                [wself updateActionButton];
                [wself updateOverlayInfo];
            }
            else if (errorMessage != nil)
            {
                [wself showAlertWithMessage:errorMessage];
            }
        }];
    }
}

- (void)printItem:(ItemInformation *)itemInfo
{
    NSString *str=[[NSBundle mainBundle] pathForResource:@"label" ofType:@"zpl"];
    NSData *data = [ZPLGenerator generateZPLWithItem:itemInfo patternPath:str];
    [_printVC printZPL:data copies:1];
    _printVC.view.hidden = NO;
}

#pragma mark printer delegate

- (void)printerDidFinishPrinting
{
    _printVC.view.hidden = YES;
    
    TaskItemInformation *taskItemInfo = [self taskItemInfoForItemWithID:_itemInPrintQueue.itemId];
    taskItemInfo.scanned += 1;
    [[MCPServer instance] saveTaskItem:nil taskID:_task.taskID itemID:taskItemInfo.itemID scanned:taskItemInfo.scanned];
    
    NSUInteger index = [_items indexOfObject:_itemInPrintQueue];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self updateOverlayInfo];
    
    _itemInPrintQueue = nil;
}

- (void)printerDidFailPrinting:(NSError *)error
{
    _printVC.view.hidden = YES;
    _itemInPrintQueue = nil;
}

#pragma mark Helpers

- (ItemInformation *)itemInfoForTaskItemWithID:(NSUInteger)ID
{
    for (ItemInformation *itemInfo in _items)
        if (itemInfo.itemId == ID)
            return itemInfo;
    
    return nil;
}

- (TaskItemInformation *)taskItemInfoForItemWithID:(NSUInteger)ID
{
    for (TaskItemInformation *taskItemInfo in _task.items)
        if (taskItemInfo.itemID == ID)
            return taskItemInfo;
    
    return nil;
}

@end
