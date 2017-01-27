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
#import "AppAppearance.h"

@interface ReceivesListViewController () <AcceptanesDelegate>
{
    NSArray *_items;
    NSDateFormatter *_dateFormatter;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ReceivesListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = AppAppearance.sharedApperance.tableViewSeparatorColor;
    self.tableView.separatorStyle = AppAppearance.sharedApperance.tableViewSeparatorStyle;
    self.tableView.separatorInset = AppAppearance.sharedApperance.tableViewSeparatorInsets;
    self.tableView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivesListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.dateFormat = @"d MMMM yyyy";
    
    self.title = NSLocalizedString(@"Приёмка", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    
}

- (void)loadData
{
    [[MCPServer instance] acceptanes:self shopID:nil progress:nil];
}

- (void)acceptanesComplete:(int)result items:(NSArray<NSDate*>*)items
{
    if (result == 0)
    {
        NSMutableArray *dates = [NSMutableArray arrayWithArray:items];
        NSArray *closedDates = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ClosedAcceptions"];
        
        for (NSDate *closedDate in closedDates)
        {
            for (NSDate *date in dates)
            {
                if ([closedDate compare:date] == NSOrderedSame)
                {
                    [dates removeObject:date];
                    break;
                }
            }
        }
        _items = dates;
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
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"receiveRootSegue" sender:indexPath];
}

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return _items.count < 1 ? NSLocalizedString(@"Нет открытых приёмок", nil) : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    
    footer.textLabel.font = [UIFont boldSystemFontOfSize:12];
    footer.textLabel.frame = footer.frame;
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"receiveRootSegue"])
    {
        NSIndexPath *indexPath = sender;
        
        ReceiveViewController *dvc = segue.destinationViewController;
        dvc.date = _items[indexPath.row];
        dvc.rootItem = nil;
    }
}

- (void)createViewControllersHierarhyWithAcceptanesInfos:(NSArray<AcceptanesInformation*>*)acceptInfos
{
    NSMutableArray *viewControllers = [NSMutableArray new];
    NSDate *date = [acceptInfos.lastObject.date copy];
    
    for (int i = 0; i <= [self.navigationController.viewControllers indexOfObject:self]; i++)
        [viewControllers addObject:[self.navigationController.viewControllers objectAtIndex:i]];
    
    ReceiveViewController *rootVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReceiveVC"];
    rootVC.date = date;
    
    [viewControllers addObject:rootVC];
    
    for (AcceptanesInformation *acceptInfo in acceptInfos)
    {
        ReceiveViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReceiveVC"];
        vc.date = date;
        vc.rootItem = acceptInfo;
        [viewControllers addObject:vc];
    }
    
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

@end
