//
//  SettingGroupCase.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "SettingGroupCase.h"
#import "SettingAction.h"
#import "SettingsCell.h"
#import "SettingsSwitchCell.h"
#import "DTDevices.h"

@implementation SettingGroupCase

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Настройки чехла";
        SettingAction *resetScannerAction = [self resetScannerAction];
        SettingAction *soundWhileScanAction = [self soundWhileScanAction];
        self.settingActions = @[resetScannerAction, soundWhileScanAction];
    }
    return self;
}

- (SettingAction *)resetScannerAction
{
    SettingAction *action = [SettingAction new];
    action.title = @"Сбросить сканер";
    action.nibIdentifier = @"SettingsCell";
    
    action.action = ^{
        
        DTDevices *dtdev = [DTDevices sharedDevice];
        
        if (dtdev.connstate != CONN_CONNECTED)
        {
            [self showInfoMessage:NSLocalizedString(@"Чехол не подключен", nil)];
            return;
        }
        
        [dtdev barcodeEngineResetToDefaults:nil];
        [self showInfoMessage:NSLocalizedString(@"Сканер успешно сброшен", nil)];
        return;
    };
    
    __block __weak SettingAction *wAction = action;
    action.updateCell = ^{
        
        if ([wAction.cell isKindOfClass:[SettingsCell class]])
        {
            SettingsCell *cell = (SettingsCell *)wAction.cell;
            cell.titleLabel.text = wAction.title;
            cell.titleLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        }
    };
    
    return action;
}

- (SettingAction *)soundWhileScanAction
{
    SettingAction *action = [SettingAction new];
    action.title = @"Звук при сканировании";
    action.nibIdentifier = @"SettingsSwitchCell";
    
    __block __weak SettingAction *wAction = action;
    action.updateCell = ^{
        
        if ([wAction.cell isKindOfClass:[SettingsSwitchCell class]])
        {
            SettingsSwitchCell *cell = (SettingsSwitchCell *)wAction.cell;
            cell.titleLabel.text = wAction.title;
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ScanSoundEnabled"])
                cell.switchControl.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ScanSoundEnabled"] boolValue];
            else
                cell.switchControl.on = YES;
            
            [cell.switchControl addTarget:self action:@selector(soundSwitchDidTriggered:) forControlEvents:UIControlEventValueChanged];
        }
    };
    
    action.action = ^{ };
    
    return action;
}

- (void)soundSwitchDidTriggered:(UISwitch *)sender
{
    DTDevices *dtdev = [DTDevices sharedDevice];
    
    if (dtdev.connstate != CONN_CONNECTED)
    {
        [sender setOn:!sender.on animated:YES];
        [self showInfoMessage:NSLocalizedString(@"Чехол не подключен", nil)];
        return;
    }
    
    NSNumber *enabled = [NSNumber numberWithBool:sender.on];
    int beep2[]={2730,250};
    NSError* error = nil;
    if (sender.on)
    {
        [dtdev barcodeSetScanBeep:TRUE volume:100 beepData:beep2 length:sizeof(beep2) error:nil];
        [dtdev playSound:100 beepData:beep2 length:sizeof(beep2) error:&error];
    }else
    {
        [dtdev barcodeSetScanBeep:FALSE volume:0 beepData:nil length:0 error:&error];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:enabled forKey:@"ScanSoundEnabled"];
}

- (void)showInfoMessage:(NSString *)message
{
    SettingAction *action = self.settingActions[0];
    if ([action.delegateViewController respondsToSelector:@selector(showInfoMessage:)])
        [action.delegateViewController performSelector:@selector(showInfoMessage:) withObject:message];
}

@end
