//
//  PaymentViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 31.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "PaymentViewController.h"
#import "MCPServer.h"
#import "PLManager.h"
#import "AppDelegate.h"

@interface PaymentViewController () <PrinterDelegate, SendPaymentDelegate, PLManagerDelegate>
{
    BOOL shouldContinueStatusCheck;
    BOOL loopMode;
    BOOL isPriinterChecked;
    PLManager* paymentLibrary;
}

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _amountLabel.text = [NSString stringWithFormat:@"%@ ₽", _amount];
    // Do any additional setup after loading the view.
    
    _slipLabel.hidden       = YES;
    _slipButton.hidden      = YES;
    _fiscalLabel.hidden     = YES;
    _fiscalButton.hidden    = YES;
    _giftLabel.hidden       = YES;
    _giftButton.hidden      = YES;
    
    paymentLibrary = [PLManager instance];
    paymentLibrary.delegate = self;
    [self checkPrinterStatus];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [paymentLibrary cancelAllOperations];
    
    if (isPriinterChecked)
    {
        _restartPayment.hidden = NO;
        _restartPayment.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    //if (track2.length > 0)
    //    [self cardSwipeAction:nil];
}

- (IBAction) switchBackToCart:(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CleanAllData" object:nil];
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (IBAction)checkPrinterStatus
{
    _restartPayment.enabled = NO;
    _placeholderLabel.text = @"Проверка статуса ФР...";
    [_activityIndicator startAnimating];
    [[MCPServer instance] printStatus:self receiptId:_receiptId];
    //[[MCPServer instance] sendPayment:self amount:_amount.doubleValue authCode:@"123456" transactionCode:@"987654321" card:@"4281********1234" receiptId:_receiptId];
}

- (IBAction)restartPaymentAction:(id)sender
{
    if (isPriinterChecked)
    {
        [self performBankPayment];
    }
    else
    {
        [self checkPrinterStatus];
    }
}

- (void) performBankPayment
{
    [_activityIndicator stopAnimating];
    _restartPayment.enabled = NO;
    _placeholderLabel.hidden = NO;
    _placeholderLabel.text = @"Вставьте карту оплаты или приложите ее к считывателю";
    NSError* error;
    [paymentLibrary payment:_amount.doubleValue error:&error];
    
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
        _restartPayment.hidden = NO;
        _restartPayment.enabled = YES;
        _placeholderLabel.text = @"Во время оплаты произошла ошибка. Попробуйте снова.";
    }
    //[self sendPaymentInfo];
}

- (void) sendPaymentInfo:(PLOperationResult*) result
{
    
    [[MCPServer instance] sendPayment:self operation:result receiptId:_receiptId amount:_amount.doubleValue];
    [[MCPServer instance] sendLoyalty:nil receiptId:_receiptId];
}

- (IBAction)repeatPrint:(UIButton*)sender
{
    NSString* type = @"0";
    
    if (sender == _slipButton)
        type = @"0";
    else if (sender == _fiscalButton)
        type = @"1";
    else if (sender == _giftButton)
        type = @"2";
    
    sender.enabled = NO;
    if (!_activityIndicator.isAnimating)
        [_activityIndicator startAnimating];
    [[MCPServer instance] repeatPrint:self type:type receiptID:_receiptId reqId:type];
}

#pragma mark - Network Delegates

- (void) restartPrinterQueueComplete:(int)result
{
    
}

- (void) printRepeatComplete:(int)result reqID:(id)reqID
{
    UIButton* referencedButton = nil;
    NSString* localizedType = nil;
    if ([reqID isEqualToString:@"0"])
    {
        referencedButton = _slipButton;
        localizedType = @"слипа";
    }
    else if ([reqID isEqualToString:@"1"])
    {
        referencedButton = _fiscalButton;
        localizedType = @"фискального чека";
    }
    else if ([reqID isEqualToString:@"2"])
    {
        referencedButton = _giftButton;
        localizedType = @"подарочного чека";
    }
    
    if (result == 0)
    {
        shouldContinueStatusCheck = YES;
        [[MCPServer instance] printStatus:self receiptId:_receiptId];
        
    }
    else{
        [self showInfoMessage:[NSString stringWithFormat:@"Не удалось перезапустить печать %@", localizedType]];
        referencedButton.enabled = YES;
        if (!shouldContinueStatusCheck)
            [_activityIndicator stopAnimating];
    }
}

- (void) printStatusComplete:(int)result detailedDescription:(PrinterStatus *)status
{
    if (result == 0)
    {
        if (status.fiscalStatus && status.queueStatus)
        {
            if (!loopMode)
            {
                [self performBankPayment];
            }
            else
                [self updatePrintingForms:status];
        }
        else
        {
            [_activityIndicator stopAnimating];
            
            if (!status.fiscalStatus && status.queueStatus)
                [self showInfoMessage:[NSString stringWithFormat:@"Оплата невозможна. %@", status.fiscalDescription?status.fiscalDescription:@""]];
            else
                [self showInfoMessage:[NSString stringWithFormat:@"Оплата невозможна. %@", status.queueDescription?status.queueDescription:@""]];
            
            _placeholderLabel.text = @"Во время оплаты произошла ошибка. Попробуйте снова.";
            
            if (!isPriinterChecked)
            {
                _restartPayment.hidden = NO;
                _restartPayment.enabled = YES;
            }
        }
            
    }
    else
    {
        [self showInfoMessage:@"Не удалось проверить статут принтера"];
    }
}

- (void) updatePrintingForms:(PrinterStatus*) status
{
    BOOL shouldContinueChecking = NO;
    
    for (PrintingForm *form in status.printingForms) {
        UILabel* formLabel = nil;
        UIButton *restartButton = nil;
        
        switch (form.type) {
            case 0:
                formLabel = _slipLabel;
                restartButton = _slipButton;
                break;
            case 1:
                formLabel = _fiscalLabel;
                restartButton = _fiscalButton;
                break;
            case 2:
                formLabel = _giftLabel;
                restartButton = _giftButton;
                break;
                
            default:
            {
            }
                break;
        }
        
        if (formLabel && restartButton)
        {
            formLabel.hidden = NO;
            if (!form.isPrinting && form.error)
            {
                restartButton.hidden  = NO;
                restartButton.enabled = YES;
                formLabel.text = [NSString stringWithFormat:@"%@: %@", form.name, form.error.localizedDescription];
            }
            else if (form.isPrinting)
            {
                formLabel.text = [NSString stringWithFormat:@"%@: Напечатан", form.name];
            }
            else
            {
                shouldContinueChecking = YES;
                formLabel.text = [NSString stringWithFormat:@"%@: Печать...", form.name];
            }
        }
    }
    
    if (shouldContinueChecking)
        [[MCPServer instance] printStatus:self receiptId:_receiptId];
    else
    {
        _transactionSuccessView.hidden = NO;
        [_activityIndicator stopAnimating];
    }
}

- (void) sendPaymentComplete:(int)result
{
    if (result == 0)
    {
        loopMode = YES;
        [[MCPServer instance] printStatus:self receiptId:_receiptId];
    }
    else
    {
        [_activityIndicator stopAnimating];
        [self showInfoMessage:@"Не удалось передать данные оплаты"];
    }
}


- (void) sendLoyaltyComplete:(int)result
{
}

- (void) showInfoMessage:(NSString*) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
}

#pragma mark - Payment Library Delegate

- (void) paymentManagerWillRequestPINEntry
{
    _placeholderLabel.text = @"Введинте ПИН с клавиатуры терминала.";
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.workspace.sideBarGestureEnabled = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void) paymentManagerDidReceivePINEntry:(BOOL)success
{
    if (!success)
    {
        [self showInfoMessage:@"Ошибка при вводе ПИН кода. Введите ПИН повторно"];
        //[self performBankPayment];
    }
}

- (void) paymentManagerWillRequestCardSwipe
{
    
}

- (void) paymentManagerDidReceiveCardSwipe
{
    
}

- (void) paymentManagerWillStartOperation:(PLOperationType)operation
{
    _placeholderLabel.text = @"Выполняется платеж с банком...";
    [_activityIndicator startAnimating];
}

- (void) paymentManagerDidFinishOperation:(PLOperationType)operation result:(PLOperationResult *)result
{
    self.navigationItem.hidesBackButton = NO;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.workspace.sideBarGestureEnabled = YES;
    
    if (!result.success)
    {
        [_activityIndicator stopAnimating];
        
        NSString* errorMessage =  nil;
        switch (result.resultCode) {
            case 504:
                errorMessage = @"Ошибка. На счету клиента недостаточно средств.";
                break;
            case 508:
                errorMessage = @"Ошибка. Неверно введен ПИН.";
                break;
            case 509:
                errorMessage = @"Ошибка. Неверно введен ПИН. Осталась последняя попытка.";
                break;
                
            default:
                errorMessage = [NSString stringWithFormat:@"Ошибка выполнения платежа. %@", result.errorLocalizedDescription];
                break;
        }
        
        [self showInfoMessage:errorMessage];
        _restartPayment.hidden = NO;
        _restartPayment.enabled = YES;
        _placeholderLabel.text = @"Для повроторного платежа нажмите \"Поврторить платеж\"";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self performBankPayment];
        });
    }
    else
    {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result.referenceNumber forKey:@"lastReferenceNumber"];
        [defaults setObject:_amount forKey:@"lastAmount"];
        [defaults synchronize];
        
        _restartPayment.hidden = YES;
        [self sendPaymentInfo:result];
        _placeholderLabel.hidden = YES;
    }
    
    [self changeTerminalBalance:operation amount:_amount.doubleValue];
}

- (void) changeTerminalBalance:(PLOperationType) operation amount:(double) amount
{
    switch (operation) {
        case PLOperationTypePayment:
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *balance = [defaults objectForKey:@"Balance"];
            NSNumber* newBalance = @(balance.doubleValue+amount);
            [defaults setObject:newBalance forKey:@"Balance"];
            
            
        }
            break;
        case PLOperationTypeReversal:
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSNumber *balance = [defaults objectForKey:@"Balance"];
            NSNumber* newBalance = @(balance.doubleValue-amount);
            [defaults setObject:newBalance forKey:@"Balance"];
        }
            break;
        case PLOperationTypeCutover:
            
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSNumber* newBalance = @(0);
            [defaults setObject:newBalance forKey:@"Balance"];
            
        }
            break;
            
        default:
            break;
    }
}

- (NSString*) maskedNumberOutOfTrack:(NSString*) track2
{
    NSRange eqRange = [track2 rangeOfString:@"=" options:0];
    NSString* cutEnd = [track2 substringToIndex:eqRange.location];
    NSString* cut = [cutEnd substringFromIndex:1];
    
    return cut;
    
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
