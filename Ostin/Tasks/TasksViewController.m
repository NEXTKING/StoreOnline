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
#import "MCPServer.h"

@interface TasksViewController () <TasksDelegate>
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

    [self loadData];
}

- (void)loadData
{
    [[MCPServer instance] tasks:self userID:@(0)];
}

- (void)tasksComplete:(int)result tasks:(NSArray<TaskInformation *> *)tasks
{
    if (result == 0)
    {
        _tasks = tasks;
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"tasks result != 0");
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TasksCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TaskInformation *task = [_tasks objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = task.name;
    cell.statusLabel.text = [NSString stringWithFormat:@"%ld", task.status];
    
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
        TaskInformation *task = [_tasks objectAtIndex:indexPath.row];
        ItemsListViewController *dvc = segue.destinationViewController;
        
        dvc.tasksMode = YES;
        dvc.task = task;
    }
}

@end
