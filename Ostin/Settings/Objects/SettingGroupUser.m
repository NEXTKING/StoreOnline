//
//  SettingGroupUser.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "SettingGroupUser.h"
#import "SettingsCell.h"
#import "AppDelegate.h"

@implementation SettingGroupUser

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Учетная запись";
        SettingAction *userInfoAction = [self userInfoAction];
        SettingAction *logoutAction = [self logoutAction];
        self.settingActions = @[userInfoAction, logoutAction];
    }
    return self;
}

- (SettingAction *)userInfoAction
{
    SettingAction *action = [SettingAction new];
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
    action.title = userName ? userName : @"-";
    action.nibIdentifier = @"SettingsCell";
    
    __block __weak SettingAction *wAction = action;
    action.updateCell = ^{
        
        if ([wAction.cell isKindOfClass:[SettingsCell class]])
        {
            SettingsCell *cell = (SettingsCell *)wAction.cell;
            
            cell.titleLabel.text = wAction.title;
            cell.titleLabel.textColor = [UIColor blackColor];
        }
    };
    
    action.action = ^{ };
    
    return action;
}

- (SettingAction *)logoutAction
{
    SettingAction *action = [SettingAction new];
    action.title = @"Сменить пользователя";
    action.nibIdentifier = @"SettingsCell";
    
    __block __weak SettingAction *wAction = action;
    action.updateCell = ^{
        
        if ([wAction.cell isKindOfClass:[SettingsCell class]])
        {
            SettingsCell *cell = (SettingsCell *)wAction.cell;
            
            cell.titleLabel.text = wAction.title;
            cell.titleLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        }
    };
    
    action.action = ^{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate resetWindowToInitialView];
        
    };
    
    return action;
}

@end
