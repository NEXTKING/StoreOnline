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
    NSArray *_items;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;

@end

@implementation ItemsListViewController

static NSString * const reuseIdentifier = @"AllItemsIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemsListCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    // [self requestData];
    [self updateOverlayInfo];
}

- (void)updateOverlayInfo
{
    if (_task != nil)
    {
        TasksNavigationController *navVC = (TasksNavigationController *)self.navigationController;
        __block NSInteger totalCount = 0;
        __block NSInteger completeCount = 0;
        
        [_task.items enumerateObjectsUsingBlock:^(TaskItemInformation *item, NSUInteger idx, BOOL *stop) {
            totalCount += item.quantity;
            completeCount += item.scanned;
        }];
        
        [navVC.overlayController setTitleText:_task.name startDate:_task.startDate totalItemsCount:totalCount completeItemsCount:completeCount];
    }
}

- (void)testActionButton
{
    self.actionButton.title = @"Начать";
    self.actionButton.enabled = YES;
    
    self.actionButton.title = @"Завершить";
    self.actionButton.enabled = YES;
    
    self.actionButton.title = @"Завершено";
    self.actionButton.enabled = NO;
}

- (void) requestData
{
    [[MCPServer instance] itemDescription:self itemCode:nil shopCode:nil isoType:0];
}

- (IBAction)actionButtonPressed:(id)sender
{
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _task.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    TaskItemInformation *taskItemInfo = _task.items[indexPath.row];
    ItemInformation *item = _tasksMode ? [self itemInfoForTaskItemWithID:taskItemInfo.itemID] : _items[indexPath.row];
    
    cell.articleLabel.text = item != nil ? item.article : @"";
    cell.nameLabel.text = item != nil ? item.name : @"";
    cell.barcodeLabel.text = item != nil ? item.barcode : @"";
    
    cell.quantityLabel.hidden = !_tasksMode;
    cell.quantityLabel.text = _tasksMode ? [NSString stringWithFormat:@"Количество %ld из %ld", taskItemInfo.scanned, taskItemInfo.quantity] : @"";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailDescriptionSegue" sender:indexPath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    OstinViewController* ostinVC = segue.destinationViewController;
//    NSIndexPath *indexPath = sender;
//    
//    ItemInformation* itemInfo = _items[indexPath.row];
//    ostinVC.externalBarcode = itemInfo.barcode;
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
        _items = items;
        [self.tableView reloadData];
    }
    else
    {
        
    }
}

- (ItemInformation *)itemInfoForTaskItemWithID:(NSUInteger)ID
{
    for (ItemInformation *info in _items)
        if (info.itemId == ID)
            return info;
    
    return nil;
}

@end
