//
//  ReceivesListViewController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ReceivesListViewController.h"
#import "ReceivesListCell.h"
#import "ReceiveViewController.h"

@interface ReceivesListViewController ()
{
    NSArray *_items;
}
@end

@implementation ReceivesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivesListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    _items = @[@{@"date":@"8 ноября 2016, 16:30", @"isComplete": @(NO)}, @{@"date":@"8 ноября 2016, 12:30", @"isComplete": @(YES)}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceivesListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *item = _items[indexPath.row];
    
    cell.titleLabel.text = item[@"date"];
    cell.backgroundColor = [item[@"isComplete"] boolValue] ? [UIColor colorWithRed:126/255.0 green:211/255.0 blue:33/255.0 alpha:0.5] : [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:0.3];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"receiveRootSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"receiveRootSegue"])
    {
        NSIndexPath *indexPath = sender;
        NSDictionary *item = _items[indexPath.row];
        
        ReceiveViewController *dvc = segue.destinationViewController;
        dvc.isRootController = YES;
        dvc.item = [NSString stringWithFormat:@"Приёмка %@", item[@"date"]];
    }
}

@end
