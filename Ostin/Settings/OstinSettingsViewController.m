//
//  OstinSettingsViewController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "OstinSettingsViewController.h"
#import "SynchronizationController.h"

@interface OstinSettingsViewController () <UITableViewDelegate, UITableViewDataSource, SyncronizationDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation OstinSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableSet *identifiersSet = [NSMutableSet new];
    for (SettingGroup *group in self.settingsGroups)
    {
        for (SettingAction *action in group.settingActions)
        {
            [identifiersSet addObject:action.nibIdentifier];
            action.delegateViewController = self;
        }
    }
    NSArray *nibIdentifiers = [identifiersSet allObjects];
    for (NSString *nibIdentifier in nibIdentifiers)
    {
        [self.tableView registerNib:[UINib nibWithNibName:nibIdentifier bundle:nil] forCellReuseIdentifier:nibIdentifier];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SynchronizationController.sharedInstance.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SynchronizationController.sharedInstance.delegate = nil;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingsGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SettingGroup *group = self.settingsGroups[section];
    return group.settingActions.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    SettingGroup *group = self.settingsGroups[section];
    return group.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingGroup *group = self.settingsGroups[indexPath.section];
    SettingAction *action = group.settingActions[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:action.nibIdentifier forIndexPath:indexPath];
    
    action.cell = cell;
    action.updateCell();
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingGroup *group = self.settingsGroups[indexPath.section];
    SettingAction *action = group.settingActions[indexPath.row];
    
    action.action();
    
    [self reloadVisibleRows];
}

#pragma mark - Syncronization Delegate

- (void)syncProgressChanged:(double)progress
{
    [self reloadVisibleRows];
}

- (void)syncCompleteWithResult:(int)result
{
    [self reloadVisibleRows];
    
//    NSString *message = result == 0 ? @"Синхронизация успешно завершена" : @"Произошла ошибка при синхронизации";
//    [self showInfoMessage:message];
}

- (void)resetPortionsCompleteWithResult:(int)result
{
    [self reloadVisibleRows];
    
    NSString *message = result == 0 ? @"Порции сброшены успешно" : @"Произошла ошибка при сбросе порций";
    [self showInfoMessage:message];
}

#pragma mark - Other

- (void)showInfoMessage:(NSString*)info
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:info preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ac dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)reloadVisibleRows
{
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:visiblePaths withRowAnimation:UITableViewRowAnimationNone];
}

@end
