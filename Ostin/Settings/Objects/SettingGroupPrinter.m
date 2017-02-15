//
//  SettingGroupPrinter.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "SettingGroupPrinter.h"
#import "SettingsCell.h"

@implementation SettingGroupPrinter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Настройки принтера";
        SettingAction *bindPrinterAction = [self bindPrinterAction];
        self.settingActions = @[bindPrinterAction];
    }
    return self;
}

- (SettingAction *)bindPrinterAction
{
    SettingAction *action = [SettingAction new];
    action.title = @"Привязать принтер";
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
        
        NSLog(@"bind printer action");
    };
    
    return action;
}

@end
