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
#import "PrintServer.h"

@interface ItemsListViewController () <ItemDescriptionDelegate>
{
    NSMutableArray *_items;
    UIActivityIndicatorView *_activityIndicator;
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
}

- (void)updateOverlayInfo
{
    if (_task != nil)
    {
        TasksNavigationController *navVC = (TasksNavigationController *)self.navigationController;
        BOOL timerIsRunning = _task.status == TaskInformationStatusInProgress;
        __block NSInteger totalCount = 0;
        __block NSInteger completeCount = 0;
        __block NSInteger excessCount = 0;
        
        [_task.items enumerateObjectsUsingBlock:^(TaskItemInformation *item, NSUInteger idx, BOOL *stop) {
            totalCount += item.quantity;
            completeCount += item.scanned > item.quantity ? item.quantity : item.scanned;
            excessCount += item.scanned > item.quantity ? item.scanned - item.quantity : 0;
        }];
        
        [navVC.overlayController setTitleText:_task.name startDate:_task.startDate endDate:_task.endDate totalItemsCount:totalCount completeItemsCount:completeCount excessItemsCount:excessCount totalPrintedCount:_task.totalPrintedCount timerIsRunning:timerIsRunning];
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
            [self subscribeToPrinterNotifications];
        }
        else if (_task.status == TaskInformationStatusComplete)
        {
            [self unsubscribeFromScanNotifications];
            [self unsubscribeFromPrinterNotifications];
        }
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
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ac dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)showInfoAlertWithMessage:(NSString*)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelAction];
    [self presentViewController:ac animated:YES completion:nil];
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

- (void)subscribeToPrinterNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFinishPrintNotification:) name:@"PrinterDidFinishPrinting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveFailPrintNotification:) name:@"PrinterDidFailPrinting" object:nil];
}

- (void)unsubscribeFromPrinterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BarcodeScanNotification" object:nil];
}

- (void)didReceiveScanNotification:(NSNotification *)notification
{
    NSString *barcode = notification.object[@"barcode"];
    NSNumber *type = notification.object[@"type"];
    [self itemDidScannedWithBarcode:barcode type:type];
}

- (void)didReceiveFinishPrintNotification:(NSNotification *)notification
{
    ItemInformation *item = notification.object;
    TaskItemInformation *taskItemInfo = [self taskItemInfoForItemWithID:item.itemId];
    _task.totalPrintedCount += 1;
    [[MCPServer instance] savePrintItemsCount:_task.totalPrintedCount inTaskWithID:_task.taskID];
    
    if (taskItemInfo != nil)
    {
        taskItemInfo.scanned += 1;
        [[MCPServer instance] saveTaskItem:nil taskID:_task.taskID itemID:taskItemInfo.itemID scanned:taskItemInfo.scanned];
        [[MCPServer instance] savePrintItemFactForItemCode:item.article taskName:_task.name];
        
        NSUInteger index = [_items indexOfObject:[self itemInfoForTaskItemWithID:taskItemInfo.itemID]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self updateOverlayInfo];
}

- (void)didReceiveFailPrintNotification:(NSNotification *)notification
{
    
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
        ItemInformation *item = _items[indexPath.row];
        TaskItemInformation *taskItemInfo = [self taskItemInfoForItemWithID:item.itemId];
        
        cell.articleLabel.text = item.article;
        cell.nameLabel.text = item.name;
        cell.barcodeLabel.text = [NSString stringWithFormat:@"Штрих-код: %@", item.barcode];
        
        cell.quantityLabel.hidden = NO;
        cell.quantityLabel.text = [NSString stringWithFormat:@"Количество: %ld из %ld", taskItemInfo.scanned, taskItemInfo.quantity];
        UIColor *greenColor = [UIColor colorWithRed:215/255.0 green:1.0 blue:215/255.0 alpha:1.0];
        UIColor *whiteColor = [UIColor whiteColor];
        cell.backgroundColor = (taskItemInfo.scanned >= taskItemInfo.quantity) && taskItemInfo.quantity != 0 ? greenColor : whiteColor;
        
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
        ostinVC.externalBarcode = itemInfo.barcode;
    }
}

#pragma mark Network Delegate

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (result == 0)
    {
        
    }
    else
    {
        
    }
}

- (void) allItemsDescription:(int)result items:(NSArray<ItemInformation *> *)items
{
    if (result == 0)
    {
        [_items removeAllObjects];
        [_items addObjectsFromArray:items];
        [self.tableView reloadData];
    }
    else
    {
        
    }
}

#pragma mark Core logic

- (void)requestData
{
    if (_tasksMode)
    {
        NSMutableArray *itemsIDs = [NSMutableArray new];
        for (TaskItemInformation *taskItemInformation in _task.items)
        {
            [itemsIDs addObject:@(taskItemInformation.itemID)];
        }
        [[MCPServer instance] itemsDescription:self itemIDs:itemsIDs];
    }
}

- (void)itemDidScannedWithBarcode:(NSString *)barcode type:(NSNumber *)type
{
    ItemInformation *item;
    NSString *internalBarcode = [BarcodeFormatter normalizedBarcodeFromString:barcode isoType:type.intValue];
    NSDictionary *barcodeData = [BarcodeFormatter dataFromBarcode:barcode isoType:type.intValue];
    
    for (ItemInformation *itemInfo in _items)
        if ([itemInfo.barcode isEqualToString:internalBarcode])
        {
            item = itemInfo;
            break;
        }
    
    if (item != nil)
    {
        double barcodePrice = barcodeData != nil ? [barcodeData[@"price"] doubleValue] : -1;
        double retailPrice = [[item additionalParameterValueForName:@"retailPrice"] doubleValue];
        double catalogPrice = item.price;
        
        if (MIN(retailPrice, catalogPrice) != barcodePrice)
        {
            [self playSound:1];
            [self printItem:item];
        }
        else
            [self playSound:0];
    }
    else
    {
        [self showAlertWithMessage:@"Товар не относится к текущему заданию"];
        [self playSound:2];
        
        __weak typeof(self) wself = self;
        double barcodePrice = barcodeData != nil ? [barcodeData[@"price"] doubleValue] : -1;
        [[MCPServer instance] itemDescriptionWithItemCode:internalBarcode isoType:type.intValue completion:^(BOOL success, ItemInformation *item) {
            
            if (success)
            {
                double retailPrice = [[item additionalParameterValueForName:@"retailPrice"] doubleValue];
                double catalogPrice = item.price;
                
                if (MIN(retailPrice, catalogPrice) != barcodePrice)
                {
                    [wself playSound:1];
                    [wself printItem:item];
                }
                else
                    [wself playSound:0];
            }
        }];
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
                [wself showInfoAlertWithMessage:errorMessage];
            }
        }];
    }
}

- (void)printItem:(ItemInformation *)itemInfo
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterID"] != nil)
    {
        [[PrintServer instance] addItemToPrintQueue:itemInfo printFormat:@"mainZPL"];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PrintAdditionalLabel"])
            [[PrintServer instance] addItemToPrintQueue:itemInfo printFormat:@"additionalZPL"];
    }
    else
    {
        [self showAlertWithMessage:@"Принтер не привязан"];
    }
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

- (void)playSound:(int)number
{
    DTDevices *dtDev = [DTDevices sharedDevice];
    
    if (number == 0) // price is actual
    {
        int data[]={300,70,500,70,700,70,900,70};
        [dtDev playSound:100 beepData:data length:sizeof(data) error:nil];
    }
    else if (number == 1) // waiting print
    {
        int data[]={800,400,0,200,800,400};
        [dtDev playSound:100 beepData:data length:sizeof(data) error:nil];
    }
    else if (number == 2) // ware not found in task
    {
        int data[]={900,50,1100,50,1300,50,1500,50};
        [dtDev playSound:100 beepData:data length:sizeof(data) error:nil];
    }
}

@end
