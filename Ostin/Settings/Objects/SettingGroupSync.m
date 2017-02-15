//
//  SettingGroupSync.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "SettingGroupSync.h"
#import "SettingsSyncCell.h"
#import "SettingsCell.h"
#import "SynchronizationController.h"

@implementation SettingGroupSync

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Синхронизация";
        SettingAction *startSyncAction = [self startSyncAction];
        SettingAction *resetPortionsAction = [self resetPortionsAction];
        self.settingActions = @[startSyncAction, resetPortionsAction];
    }
    return self;
}

- (SettingAction *)startSyncAction
{
    SettingAction *action = [SettingAction new];
    action.title = @"Начать синхронизацию";
    action.nibIdentifier = @"SettingsSyncCell";
    
    __block __weak SettingAction *wAction = action;
    action.updateCell = ^{
        
        if ([wAction.cell isKindOfClass:[SettingsSyncCell class]])
        {
            SettingsSyncCell *cell = (SettingsSyncCell *)wAction.cell;
            
            double progress = SynchronizationController.sharedInstance.syncProgress;
            BOOL isSyncing = SynchronizationController.sharedInstance.syncIsRunning;
            
            cell.titleLabel.text = isSyncing ? [NSString stringWithFormat:@"Выполнено: %d %%", (int)(progress * 100)] : @"Начать синхронизацию";
            cell.titleLabel.textColor = isSyncing ? [UIColor blackColor] : [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
            cell.progressView.hidden = isSyncing ? NO : YES;
            cell.progressView.progress = progress;
        }
    };
    
    action.action = ^{
        
        if (!SynchronizationController.sharedInstance.syncIsRunning)
        {
            [SynchronizationController.sharedInstance synchronize];
            wAction.updateCell();
        }
    };
    
    return action;
}

- (SettingAction *)resetPortionsAction
{
    SettingAction *action = [SettingAction new];
    action.title = @"Сбросить порции";
    action.nibIdentifier = @"SettingsCell";
    
    __block __weak SettingAction *wAction = action;
    action.updateCell = ^{
        
        if ([wAction.cell isKindOfClass:[SettingsCell class]])
        {
            SettingsCell *cell = (SettingsCell *)wAction.cell;
            
            BOOL isSyncing = SynchronizationController.sharedInstance.syncIsRunning;
            
            cell.titleLabel.text = wAction.title;
            cell.titleLabel.textColor = isSyncing ? [UIColor lightGrayColor] : [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        }
    };
    
    action.action = ^{
        
        if (!SynchronizationController.sharedInstance.syncIsRunning)
        {
            [SynchronizationController.sharedInstance resetPortions];
            wAction.updateCell();
        }
    };
    
    return action;
}

@end
