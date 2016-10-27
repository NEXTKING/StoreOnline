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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (void)loadData
{
    NSNumber *userID = @([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"] integerValue]);
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MCPServer instance] tasks:wself userID:userID];
    });
}

- (void)tasksComplete:(int)result tasks:(NSArray<TaskInformation *> *)tasks
{
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result == 0)
        {
            _tasks = tasks;
            [wself.tableView reloadData];
        }
        else
        {
            
        }
    });
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
    cell.statusLabel.text = task.status == TaskInformationStatusNotStarted ? @"Новое" : task.status == TaskInformationStatusInProgress ? @"Не завершено" : @"Завершено";
    
    UIColor *greenColor = [UIColor colorWithRed:215/255.0 green:1.0 blue:215/255.0 alpha:1.0];
    UIColor *whiteColor = [UIColor whiteColor];
    cell.backgroundColor = task.status == TaskInformationStatusComplete ? greenColor : whiteColor;
    
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
