//
//  StockDetailsViewController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 01/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "StockDetailsViewController.h"
#import "StockDetailsHeaderCell.h"
#import "StockDetailsCell.h"
#import "AppAppearance.h"

@interface StockDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StockDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Остатки товара", nil);
    
    self.tableView.separatorColor = AppAppearance.sharedApperance.tableViewSeparatorColor;
    self.tableView.separatorStyle = AppAppearance.sharedApperance.tableViewSeparatorStyle;
    self.tableView.separatorInset = AppAppearance.sharedApperance.tableViewSeparatorInsets;
    self.tableView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"StockDetailsCell" bundle:nil] forCellReuseIdentifier:@"StockDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StockDetailsHeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StockDetailsHeaderCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.group.sizes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *size = self.group.sizes[section];
    return [self.group colorsForSize:size].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    StockDetailsHeaderCell *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StockDetailsHeaderCell"];
    
    NSArray *sizes = self.group.sizes;
    
    header.sizeLabel.text = sizes[section];
    header.countTitleLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Количество", nil)];
    header.countLabel.text = [NSString stringWithFormat:@"%ld", [self.group countForSize:sizes[section] color:nil]];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StockDetailsCell" forIndexPath:indexPath];
    
    NSString *size = self.group.sizes[indexPath.section];
    NSString *color = [self.group colorsForSize:size][indexPath.row];
    
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.colorLabel.text = color;
    cell.stockLabel.text = [NSString stringWithFormat:@"%ld", [self.group countForSize:size color:color]];
    
    return cell;
}

@end
