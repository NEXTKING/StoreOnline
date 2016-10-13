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
    [self setOverlayInfo];
}

- (void)setOverlayInfo
{
    if (_fakeData != nil)
    {
        NSDate *date = [_fakeData objectForKey:@"date"];
        NSString *title = [_fakeData objectForKey:@"title"];
        NSInteger total = [[_fakeData objectForKey:@"totalCount"] integerValue];
        NSInteger complete = [[_fakeData objectForKey:@"completeCount"] integerValue];
        
        TasksNavigationController *navVC = (TasksNavigationController *)self.navigationController;
        [navVC.overlayController setTitleText:title startDate:date totalItemsCount:total completeItemsCount:complete];
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
    return 1;//_items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
//    ItemInformation *itemInfo = _items[indexPath.row];
//    
//    cell.articleLabel.text = itemInfo.article;
//    cell.nameLabel.text = itemInfo.name;
//    cell.barcodeLabel.text = itemInfo.barcode;
//    
//    cell.quantityLabel.hidden = !_tasksMode;
//    cell.quantityLabel.text = @"Количество 0 из 18";
    
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

@end
