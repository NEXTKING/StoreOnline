//
//  SettingsViewController+Ostin.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 07/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SettingsViewController+Ostin.h"
#import "SettingsCell.h"
#import "SettingsSwitchCell.h"
#import "SettingsSyncCell.h"
#import "AppDelegate.h"
#import "SynchronizationController.h"

enum : NSUInteger
{
    SettingsSectionPrinterActions = 0,
    SettingsSectionScanerActions = 1,
    SettingsSectionSyncActions = 2,
    SettingsSectionUserActions = 3
};

@interface SettingsViewController_Ostin () <UITableViewDelegate, UITableViewDataSource, SyncronizationDelegate, DTDeviceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SettingsViewController_Ostin

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsCell" bundle:nil] forCellReuseIdentifier:@"SettingsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsSwitchCell" bundle:nil] forCellReuseIdentifier:@"SettingsSwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsSyncCell" bundle:nil] forCellReuseIdentifier:@"SettingsSyncCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    SynchronizationController.sharedInstance.delegate = self;
    [dtdev addDelegate:self];
}

- (void)dealloc
{
    [dtdev removeDelegate:self];
}

- (void)connectionState:(int)state
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:SettingsSectionScanerActions];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showInfoMessage:(NSString*)info
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:info preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ac dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)showResetPortionsAlert
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Сброс порций" message:@"Сброс порций приведет к удалению с устройства базы товаров. Продолжить?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Сбросить порции" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [SynchronizationController.sharedInstance resetPortions];
        [self reloadSyncActionsSection];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:resetAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate resetWindowToInitialView];
}

- (IBAction)additionalLabelSwitchDidChanged:(id)sender
{
    UISwitch *_switch = sender;
    [[NSUserDefaults standardUserDefaults] setBool:_switch.on forKey:@"PrintAdditionalLabel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)setChargingSwitchDidChanged:(id)sender
{
    UISwitch *_switch = sender;
    NSError *error = nil;
    
    [dtdev setCharging:_switch.on error:nil];
    
    if (error)
        [_switch setOn:!_switch.on animated:YES];
}

- (IBAction)setPassThroughSyncSwitchDidChanged:(id)sender
{
    UISwitch *_switch = sender;
    NSError *error = nil;
    
    [dtdev setPassThroughSync:_switch.on error:&error];
    
    if (error)
        [_switch setOn:!_switch.on animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case SettingsSectionPrinterActions:
            return _showPrintAdditionalLabelSwitch ? 2 : 1;
            break;
        case SettingsSectionScanerActions:
            return 4;
            break;
        case SettingsSectionSyncActions:
            return 2;
            break;
        case SettingsSectionUserActions:
            return 1;
            break;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case SettingsSectionPrinterActions:
            return @"Настройки принтера";
            break;
        case SettingsSectionScanerActions:
            return @"Настройки чехла";
            break;
        case SettingsSectionSyncActions:
            return @"Синхронизация";
            break;
        case SettingsSectionUserActions:
            return [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
            break;
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SettingsSectionPrinterActions && indexPath.row == 0)
    {
        SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Привязать принтер";
        cell.titleLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        return cell;
    }
    else if (indexPath.section == SettingsSectionPrinterActions && indexPath.row == 1)
    {
        SettingsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Печатать доп. этикетку";
        cell.switchControl.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"PrintAdditionalLabel"];
        [cell.switchControl addTarget:self action:@selector(additionalLabelSwitchDidChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    else if (indexPath.section == SettingsSectionScanerActions && indexPath.row == 0)
    {
        SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Сбросить сканер";
        cell.titleLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        return cell;
    }
    else if (indexPath.section == SettingsSectionScanerActions && indexPath.row == 1)
    {
        SettingsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Звук при сканировании";
        if (dtdev.connstate != CONN_CONNECTED)
        {
            cell.switchControl.enabled = NO;
            cell.switchControl.on = YES;
        }
        else
        {
            cell.switchControl.enabled = YES;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ScanSoundEnabled"])
                cell.switchControl.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ScanSoundEnabled"] boolValue];
            else
                cell.switchControl.on = YES;
        }
        [cell.switchControl addTarget:self action:@selector(soundSwitchAction:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    else if (indexPath.section == SettingsSectionScanerActions && indexPath.row == 2)
    {
        SettingsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Заряжать iOS устройство";
        if (dtdev.connstate != CONN_CONNECTED)
        {
            cell.switchControl.enabled = NO;
            cell.switchControl.on = NO;
        }
        else
        {
            cell.switchControl.enabled = YES;
            BOOL enabled = NO;
            [dtdev getCharging:&enabled error:nil];
            cell.switchControl.on = enabled;
        }
        [cell.switchControl addTarget:self action:@selector(setChargingSwitchDidChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    else if (indexPath.section == SettingsSectionScanerActions && indexPath.row == 3)
    {
        SettingsSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Pass-through sync";
        if (dtdev.connstate != CONN_CONNECTED)
        {
            cell.switchControl.enabled = NO;
            cell.switchControl.on = NO;
        }
        else
        {
            cell.switchControl.enabled = YES;
            BOOL enabled = NO;
            [dtdev getPassThroughSync:&enabled error:nil];
            cell.switchControl.on = enabled;
        }
        [cell.switchControl addTarget:self action:@selector(setPassThroughSyncSwitchDidChanged:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    else if (indexPath.section == SettingsSectionSyncActions && indexPath.row == 0)
    {
        SettingsSyncCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsSyncCell" forIndexPath:indexPath];
        double progress = SynchronizationController.sharedInstance.syncProgress;
        BOOL isSyncing = SynchronizationController.sharedInstance.syncIsRunning;
        
        cell.titleLabel.text = isSyncing ? [NSString stringWithFormat:@"Синхронизация. Выполнено: %d %%", (int)(progress * 100)] : @"Начать синхронизацию";
        cell.titleLabel.textColor = isSyncing ? [UIColor blackColor] : [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        cell.progressView.hidden = isSyncing ? NO : YES;
        cell.progressView.progress = progress;
        return cell;
    }
    else if (indexPath.section == SettingsSectionSyncActions && indexPath.row == 1)
    {
        SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
        BOOL isSyncing = SynchronizationController.sharedInstance.syncIsRunning;
        
        cell.titleLabel.text = @"Сбросить порции";
        cell.titleLabel.textColor = isSyncing ? [UIColor lightGrayColor] : [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        return cell;
    }
    else if (indexPath.section == SettingsSectionUserActions && indexPath.row == 0)
    {
        SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"Сменить пользователя";
        cell.titleLabel.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
        return cell;
    }
    else
        return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SettingsSectionPrinterActions && indexPath.row == 0)
    {
        self.bindPrinterAction();
    }
    else if (indexPath.section == SettingsSectionScanerActions && indexPath.row == 0)
    {
        [self performSelector:@selector(resetBarcodeEngine:) withObject:nil];
    }
    else if (indexPath.section == SettingsSectionSyncActions && indexPath.row == 0 && !SynchronizationController.sharedInstance.syncIsRunning)
    {
        [SynchronizationController.sharedInstance synchronize];
        [self reloadSyncActionsSection];
    }
    else if (indexPath.section == SettingsSectionSyncActions && indexPath.row == 1 && !SynchronizationController.sharedInstance.syncIsRunning)
    {
        [self showResetPortionsAlert];
    }
    else if (indexPath.section == SettingsSectionUserActions && indexPath.row == 0)
    {
        [self logout];
    }
}

#pragma mark - Syncronization Delegate

- (void)syncProgressChanged:(double)progress
{
    [self reloadSyncActionsSection];
}

- (void)syncCompleteWithResult:(int)result
{
    [self reloadSyncActionsSection];
    
    NSString *message = result == 0 ? @"Синхронизация успешно завершена" : @"Произошла ошибка при синхронизации";
    [self showInfoMessage:message];
}

- (void)resetPortionsCompleteWithResult:(int)result
{
    [self reloadSyncActionsSection];
    
    NSString *message = result == 0 ? @"Порции сброшены успешно" : @"Произошла ошибка при сбросе порций";
    [self showInfoMessage:message];
}

- (void)reloadSyncActionsSection
{
    NSIndexPath *syncRow = [NSIndexPath indexPathForRow:0 inSection:SettingsSectionSyncActions];
    NSIndexPath *portionsRow = [NSIndexPath indexPathForRow:1 inSection:SettingsSectionSyncActions];
    [self.tableView reloadRowsAtIndexPaths:@[syncRow, portionsRow] withRowAnimation:UITableViewRowAnimationNone];
}

@end
