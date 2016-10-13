//
//  TasksViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 22/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "TasksViewController.h"
#import "TasksCell.h"
#import "ItemsListViewController.h"

@interface TasksViewController ()
{
    NSArray *_tasks;
}
@end

@implementation TasksViewController

static NSString * const reuseIdentifier = @"TableCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"TasksCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    _tasks = @[@{@"taskName":@"ЗнП 580", @"taskDescription":@"Обработано 3 из 18"}, @{@"taskName":@"ЗнП 581", @"taskDescription":@"Обработано 8 из 18"}];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TasksCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *task = _tasks[indexPath.row];
    
    cell.titleLabel.text = task[@"taskName"];
    cell.statusLabel.text = task[@"taskDescription"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TaskItemsListSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TaskItemsListSegue"])
    {
        NSIndexPath *indexPath = sender;
        ItemsListViewController *dvc = segue.destinationViewController;
        
        if (indexPath.row == 0)
        {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:-1];
            
            NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
            dvc.fakeData = @{@"date":date, @"title":@"ЗнП 580", @"totalCount":[NSNumber numberWithInt:18], @"completeCount":[NSNumber numberWithInt:3]};
        }
        else
        {
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setMinute:-20];
            
            NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
            dvc.fakeData = @{@"date":date, @"title":@"ЗнП 581", @"totalCount":[NSNumber numberWithInt:18], @"completeCount":[NSNumber numberWithInt:8]};
        }
    }
}

@end
