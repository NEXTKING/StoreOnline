//
//  SettingsViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SettingsViewController.h"
#import "DTDevices.h"

enum SETTINGS{
    SET_BEEP=0,
    SET_ENABLE_SCAN_BUTTON,
    SET_AUTOCHARGING,
    SET_RESET_BARCODE,
    SET_ENABLE_SPEAKER,
    SET_ENABLE_SPEAKER_BUTTON,
    SET_ENABLE_SPEAKER_AUTO,
    SET_ENABLE_SYNC,
    SET_KIOSK,
    SET_VIBRATE,
    SET_TIMEOUTS_30_60,
    SET_TIMEOUTS_60_5400,
    SET_MIC_GAIN_5,
    SET_MIC_GAIN_10,
    SET_MIC_GAIN_15,
    SET_MIC_GAIN_20,
    SET_LAST
};

@interface SettingsViewController ()
{
    DTDevices *dtdev;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isSoundEnabled = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ScanSoundEnabled"])
    {
        isSoundEnabled = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ScanSoundEnabled"] boolValue];
        _scanSoundSwitch.on = isSoundEnabled;
    }
    else
        _scanSoundSwitch.on = YES;
    
    dtdev = [DTDevices sharedDevice];
    
    [_feedPaperButton setTitle:NSLocalizedString(@"Подача этикетки", nil) forState:UIControlStateNormal];
    [_resetBarcodeEngineButton setTitle:NSLocalizedString(@"Сбросить сканер", nil) forState:UIControlStateNormal];
    [_calibrateBlackMarkButton setTitle:NSLocalizedString(@"Калибровка", nil) forState:UIControlStateNormal];
    [_bindPrinterButton setTitle:NSLocalizedString(@"Привязка принтера", nil) forState:UIControlStateNormal];
    [_temporaryFeedButton setTitle:NSLocalizedString(@"Подача для отрыва", nil) forState:UIControlStateNormal];
    _enableScanSoundLabel.text = NSLocalizedString(@"Звук при сканировании", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calibrateBlackMarkAction:(id)sender
{
    if (_calibrateAction)
        _calibrateAction();
}

- (IBAction)resetBarcodeEngine:(id)sender
{
    if (dtdev.connstate != CONN_CONNECTED)
    {
        [self showInfoMessage:NSLocalizedString(@"Чехол не подключен", nil)];
        return;
    }
    
    [dtdev barcodeEngineResetToDefaults:nil];
    [self showInfoMessage:NSLocalizedString(@"Сканер успешно сброшен", nil)];
}

- (IBAction)bindPrinterAction:(id)sender
{
    if (_bindPrinterAction)
        _bindPrinterAction();
}

-(IBAction)temporaryFeed:(id)sender
{
    if (_temporaryFeedAction)
        _temporaryFeedAction();
}

- (IBAction)soundSwitchAction:(UISwitch*)sender
{
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

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (IBAction)feedPaperAction:(id)sender
{
    if (_feedPaperAction)
        _feedPaperAction();
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
