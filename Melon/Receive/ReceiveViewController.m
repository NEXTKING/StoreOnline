//
//  ReceiveViewController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ReceiveViewController.h"
#import "ReceivesListCell.h"
#import "ReceiveBoxCell.h"
#import "ReceiveItemCell.h"

@interface ReceiveViewController ()
{
    NSArray *_items;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivesListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveBoxCell" bundle:nil] forCellReuseIdentifier:@"BoxCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:60];
    _items = @[@{@"type":@(0), @"barcode": @"99083775922"},
               @{@"type":@(0), @"barcode": @"99083738701"},
               @{@"type":@(0), @"barcode": @"99083760976"},
               @{@"type":@(0), @"barcode": @"99082386191"},
               @{@"type":@(0), @"barcode": @"99089276501"},
               @{@"type":@(1), @"barcode": @"99089276501"},
               @{@"type":@(1), @"barcode": @"99089276501"},
               @{@"type":@(2), @"barcode": @"99089276501", @"title":@"Товар", @"scanned":@"0", @"quantity":@"10"}];
}

- (NSString *)titleText
{
    if ([self.item isKindOfClass:[NSString class]])
        return self.item;
    else
        return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isRootController ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isRootController)
        return section == 0 ? 1 : _items.count;
    else
        return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isRootController && indexPath.section == 0)
    {
        ReceivesListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = @"Общие излишки";
        
        return cell;
    }
    else
    {
        id cell;
        NSDictionary *item = _items[indexPath.row];
        switch ([item[@"type"] integerValue])
        {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell" forIndexPath:indexPath];
                [self configureBoxCell:cell forItem:item];
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell" forIndexPath:indexPath];
                [self configureGroupCell:cell forItem:item];
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
                [self configureItemCell:cell forItem:item];
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)configureBoxCell:(ReceiveBoxCell *)cell forItem:(id)item
{
    cell.iconImageView.image = [UIImage imageNamed:@"receive_box_icon"];
    cell.titleLabel.text = @"Коробка";
    cell.barcodeLabel.text = item[@"barcode"];
}

- (void)configureGroupCell:(ReceiveBoxCell *)cell forItem:(id)item
{
    cell.iconImageView.image = [UIImage imageNamed:@"receive_group_icon"];
    cell.titleLabel.text = @"Набор товаров";
    cell.barcodeLabel.text = item[@"barcode"];
}

- (void)configureItemCell:(ReceiveItemCell *)cell forItem:(id)item
{
    cell.titleLabel.text = item[@"title"];
    cell.barcodeLabel.text = item[@"barcode"];
    cell.quantityLabel.text = [NSString stringWithFormat:@"%@ из %@", item[@"scanned"], item[@"quantity"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isRootController && indexPath.section == 0)
    {
        
    }
    else
    {
        NSDictionary *item = _items[indexPath.row];
        NSInteger type = [item[@"type"] integerValue];
        if (type == 0 || type == 1)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ReceiveViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ReceiveViewController"];
            vc.item = item;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.titleText : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.text = [header.textLabel.text capitalizedString];
    header.textLabel.textColor = [UIColor lightGrayColor];
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
    header.textLabel.frame = header.frame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

@end
