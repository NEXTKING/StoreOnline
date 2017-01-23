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
#import "DPButton.h"
#import "DPSyncButton.h"
#import "AppSuspendingBlocker.h"

@interface MenuViewController () <ItemDescriptionDelegate, UIAlertViewDelegate, DTDeviceDelegate, ZonesDelegate, AcceptanesDelegate>
{
    NSInteger *reqCount;
    AppSuspendingBlocker *_suspendingBlocker;
}
@property (weak, nonatomic) IBOutlet DPSyncButton *syncButton;
@property (weak, nonatomic) IBOutlet DPButton *revaluationButton;
@property (weak, nonatomic) IBOutlet DPButton *inventoryButton;
@property (weak, nonatomic) IBOutlet DPButton *stockButton;
@property (weak, nonatomic) IBOutlet DPButton *acceptancesButton;
@property (weak, nonatomic) IBOutlet DPButton *labelsButton;

@property (nonatomic, weak) UIAlertView* syncAlertView;
@property (nonatomic, copy) NSString* currentShopID;
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDate *lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSyncDate"];
    if (lastSyncDate)
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *dateString = [dateFormatter stringFromDate:lastSyncDate];
        
        _lastSyncDateLabel.text = dateString;
    }
    else
        _lastSyncDateLabel.text = NSLocalizedString(@"Нет данных о последней синхронизации", nil);
    
    _lastSyncLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Последняя синхронизация", nil)];
    
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    _buildLabel.text = [NSString stringWithFormat:@"Build %@", build];
    [_revaluationButton setTitle:NSLocalizedString(@"Переоценка", nil) forState:UIControlStateNormal];
    [_inventoryButton setTitle:NSLocalizedString(@"Инвентаризация", nil) forState:UIControlStateNormal];
    [_stockButton setTitle:NSLocalizedString(@"Остатки товара", nil) forState:UIControlStateNormal];
    [_acceptancesButton setTitle:NSLocalizedString(@"Приёмка", nil) forState:UIControlStateNormal];
    [_labelsButton setTitle:NSLocalizedString(@"Печать ярлыков", nil) forState:UIControlStateNormal];
    [_syncButton setTitle:NSLocalizedString(@"Синхронизация", nil) forState:UIControlStateNormal];
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
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Синхронизация", nil) message:NSLocalizedString(@"Отсканируйте штрих-код магазина или введите его вручную", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Отмена", nil) otherButtonTitles:NSLocalizedString(@"Продолжить", nil), nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView show];
    self.syncAlertView = alertView;
}

- (void) startSyncing
{
    _suspendingBlocker = [AppSuspendingBlocker new];
    [_suspendingBlocker startBlock];
    
    _revaluationButton.enabled = NO;
    _inventoryButton.enabled = NO;
    _stockButton.enabled = NO;
    _acceptancesButton.enabled = NO;
    _labelsButton.enabled = NO;
    
    _syncButton.enabled = NO;
    [_syncButton startAnimation];
    [[MCPServer instance] itemDescription:self itemCode:nil shopCode:_currentShopID isoType:0];
}

- (void) finishSyncing:(BOOL) success
{
    [_suspendingBlocker stopBlock];
    
    _revaluationButton.enabled = YES;
    _inventoryButton.enabled = YES;
    _stockButton.enabled = YES;
    _acceptancesButton.enabled = YES;
    _labelsButton.enabled = YES;
    
    _syncButton.enabled = YES;
    [_syncButton stopAnimation];
    if (success)
    {
        NSDate *now = [NSDate date];
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *dateString = [dateFormatter stringFromDate:now];
        
        _lastSyncLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Последняя синхронизация", nil), dateString];
        [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"lastSyncDate"];
        [[NSUserDefaults standardUserDefaults] setObject:_currentShopID forKey:@"shopID"];
    }
    else
    {
        [self showInfoMessage:NSLocalizedString(@"Ошибка во время синхронизации", nil)];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
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
