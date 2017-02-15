//
//  SettingGroupManualInput.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "SettingGroupManualInput.h"
#import "SettingsCell.h"

@implementation SettingGroupManualInput

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Ручной ввод";
        SettingAction *manualInputAction = [self manualInputAction];
        self.settingActions = @[manualInputAction];
    }
    return self;
}

- (SettingAction *)manualInputAction
{
    SettingAction *action = [SettingAction new];
    action.title = @"Отметить товар вручную";
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
        
    };
    
    return action;
}

@end
