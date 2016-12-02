//
//  MenuViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MenuViewController.h"
#import "MCPServer.h"
#import "DTDevices.h"

@interface MenuViewController () <ItemDescriptionDelegate, UIAlertViewDelegate, DTDeviceDelegate, ZonesDelegate, AcceptanesDelegate>
{
    NSInteger *reqCount;
}
@property (nonatomic, weak) UIAlertView* syncAlertView;
@property (nonatomic, copy) NSString* currentShopID;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *lastSyncString = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSync"];
    _lastSyncLabel.text = lastSyncString ? [NSString stringWithFormat:@"Последняя синхронизация: %@", lastSyncString]:@"Нет данных о последней синхронизации";
    
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    _buildLabel.text = [NSString stringWithFormat:@"Build: %@", build];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev addDelegate:self];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev removeDelegate:self];
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    [[_syncAlertView textFieldAtIndex:0] insertText:barcode];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [[_syncAlertView textFieldAtIndex:0] insertText:barcode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)syncButtonAction:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Синхронизация" message:@"Отсканируйте штрих-код магазина или введите его вручную" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Продолжить", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView show];
    self.syncAlertView = alertView;
}

- (void) startSyncing
{
    _syncButton.enabled = NO;
    [_syncActivityIndicator startAnimating];
    [[MCPServer instance] itemDescription:self itemCode:nil shopCode:_currentShopID isoType:0];
}

- (void) finishSyncing:(BOOL) success
{
    _syncButton.enabled = YES;
    [_syncActivityIndicator stopAnimating];
    if (success)
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        _lastSyncLabel.text = [NSString stringWithFormat:@"Последняя синхронизация: %@", dateString];
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"lastSync"];
        [[NSUserDefaults standardUserDefaults] setObject:_currentShopID forKey:@"shopID"];
    }
    else
    {
        [self showInfoMessage:@"Ошика во время синхронизации"];
    }
    
    reqCount = 0;
}

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (result == 0)
    {
        
        [[MCPServer instance] zones:self shopID:_currentShopID];
    }
    else
    {
        [self finishSyncing:NO];
    }
}

- (void) zonesComplete:(int)result zones:(NSArray *)zones
{
    if (result == 0)
    {
        [[MCPServer instance] acceptanes:self shopID:_currentShopID];
    }
    else
    {
        [self finishSyncing:NO];
    }
}

- (void)acceptanesComplete:(int)result items:(NSArray *)items
{
    if (result == 0)
    {
        [self finishSyncing:YES];
    }
    else
    {
        [self finishSyncing:NO];
    }
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:info delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
        return;
    
    self.currentShopID = [alertView textFieldAtIndex:0].text;
    [self startSyncing];
}

- (BOOL) alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return ([[[alertView textFieldAtIndex:0] text] length]>0);
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
