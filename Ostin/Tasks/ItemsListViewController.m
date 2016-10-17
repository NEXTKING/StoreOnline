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

@interface ItemsListViewController () <ItemDescriptionDelegate>
{
    NSMutableArray *_items;
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
    [self updateOverlayInfo];
}

- (void)updateOverlayInfo
{
    if (_task != nil)
    {
        TasksNavigationController *navVC = (TasksNavigationController *)self.navigationController;
        BOOL timerIsRunning = _task.status != 3;
        __block NSInteger totalCount = 0;
        __block NSInteger completeCount = 0;
        
        [_task.items enumerateObjectsUsingBlock:^(TaskItemInformation *item, NSUInteger idx, BOOL *stop) {
            totalCount += item.quantity;
            completeCount += item.scanned;
        }];
        
        [navVC.overlayController setTitleText:_task.name startDate:_task.startDate totalItemsCount:totalCount completeItemsCount:completeCount timerIsRunning:timerIsRunning];
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
        if (_task.status == 0)
        {
            self.actionButton.title = @"Начать";
            self.actionButton.enabled = YES;
        }
        else if (_task.status == 1)
        {
            self.actionButton.title = @"Завершить";
            self.actionButton.enabled = YES;
        }
        else if (_task.status == 2)
        {
            self.actionButton.title = @"Завершено";
            self.actionButton.enabled = NO;
        }
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (_tasksMode)
    {
        TaskItemInformation *taskItemInfo = _task.items[indexPath.row];
        ItemInformation *item = [self itemInfoForTaskItemWithID:taskItemInfo.itemID];
        
        cell.articleLabel.text = item != nil ? item.article : @"";
        cell.nameLabel.text = item != nil ? item.name : @"";
        cell.barcodeLabel.text = item != nil ? item.barcode : @"";
        
        cell.quantityLabel.hidden = NO;
        cell.quantityLabel.text = [NSString stringWithFormat:@"Количество %ld из %ld", taskItemInfo.scanned, taskItemInfo.quantity];
    }
    else
    {
        ItemInformation *item = _items[indexPath.row];
        
        cell.articleLabel.text = item.article;
        cell.nameLabel.text = item.name;
        cell.barcodeLabel.text = item.barcode;
        
        cell.quantityLabel.hidden = YES;
    }
    
    return cell;
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
    if (result == 0)
    {
        [_items addObject:itemDescription];
        NSUInteger index = [_items indexOfObject:itemDescription];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
        for (TaskItemInformation *taskItemInformation in _task.items)
            [[MCPServer instance] itemDescription:self itemID:taskItemInformation.itemID];
    }
    else
        [[MCPServer instance] itemDescription:self itemCode:nil shopCode:nil isoType:0];
}

- (void)itemDidScannedWithBarcode:(NSString *)barcode
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
            taskItemInfo.scanned += 1;

            [[MCPServer instance] saveTaskItem:nil taskID:_task.taskID itemID:taskItemInfo.itemID scanned:taskItemInfo.scanned];

            NSUInteger index = [_items indexOfObject:item];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self updateOverlayInfo];
        }
    }
}

- (IBAction)actionButtonPressed:(id)sender
{
    if (_tasksMode)
    {
        if (_task.status == TaskInformationStatusNotStarted)
        {
            _task.status = TaskInformationStatusInProgress;
        }
        else if (_task.status == TaskInformationStatusInProgress)
        {
            _task.status = TaskInformationStatusComplete;
        }
        
        [[MCPServer instance] saveTask:nil taskID:_task.taskID userID:_task.userID status:_task.status];
        
        [self updateActionButton];
        [self updateOverlayInfo];
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

@end
