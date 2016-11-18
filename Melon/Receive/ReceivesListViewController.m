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
#import "MCPServer.h"

@interface ReceivesListViewController () <AcceptanesDelegate>
{
    NSArray *_items;
    NSDateFormatter *_dateFormatter;
}
@end

@implementation ReceivesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivesListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.dateFormat = @"d MMMM yyyy, hh:mm";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    
}

- (void)loadData
{
    [[MCPServer instance] acceptanes:self shopID:nil];
}

- (void)acceptanesComplete:(int)result items:(NSArray<NSDate*>*)items
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
    NSDate *date = _items[indexPath.row];
    
    cell.titleLabel.text = [_dateFormatter stringFromDate:date];
    
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
        
        ReceiveViewController *dvc = segue.destinationViewController;
        dvc.date = _items[indexPath.row];
    }
}

@end
