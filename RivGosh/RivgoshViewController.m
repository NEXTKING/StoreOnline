//
//  RivgoshViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 22.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "RivgoshViewController.h"
#import "CartCell.h"
#import "DTDevices.h"
#import "DiscountsViewController.h"

@interface RivgoshViewController () <UIAlertViewDelegate, ClientCardDelegate, DiscountsDelegate, ApplyDiscountsDelegate, PrinterDelegate>
{
    BOOL requestInProgress;
}

@property (nonatomic, strong) UIActivityIndicatorView* internalActivityIndicator;
@property (nonatomic, copy) NSString* currentReceiptId;
@property (nonatomic, strong) NSArray* discountArray;
@property (nonatomic, weak) UIAlertView* openShiftPlaceholder;

@end

@implementation RivgoshViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice addDelegate:self];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice removeDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice addDelegate:self];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self requestItemInformation:@"1234"];
}

- (IBAction)manualInputAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ручной ввод"
                                                    message:@"Введите ШК вручную"
                                                   delegate:self
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"Отправить",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    if (requestInProgress)
        return;
    
    if (    [barcode hasPrefix:@"5550"]
        ||  [barcode hasPrefix:@"5000"]
        ||  [barcode hasPrefix:@"9990"]
        ||  [barcode hasPrefix:@"8888"])
        [self requestClientInfoWithCode:barcode];
    else
        [self requestItemInformation:barcode];
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    if (requestInProgress)
        return;
    
    if (    [barcode hasPrefix:@"5550"]
        ||  [barcode hasPrefix:@"5000"]
        ||  [barcode hasPrefix:@"9990"]
        ||  [barcode hasPrefix:@"8888"])
        [self requestClientInfoWithCode:barcode];
    else
        [self requestItemInformation:barcode];
}


- (void) magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    NSRange trackRange = {.location = 1, .length = track2.length-2};
    NSString* cardCode = [track2 substringWithRange:trackRange];
    [self requestClientInfoWithCode:cardCode];
}


- (void) requestItemInformation:(NSString*) code
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:_currentReceiptId forKey:@"currentReceiptID"];
    requestInProgress = YES;
    [[MCPServer instance] itemDescription:self itemCode:code shopCode:nil isoType:0];
}

- (void) requestClientInfoWithCode:(NSString *)code
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:_currentReceiptId forKey:@"currentReceiptID"];
    [_headerActivity startAnimating];
    requestInProgress = YES;
    [[MCPServer instance] clinetCard:self cardNumber:code];
}

- (void) requestClientInformation:(NSString*) code
{
    
}

- (IBAction)manuallyAddItem:(id)sender
{
    //[self barcodeData:@"2756563201240" type:0];
    [self barcodeData:@"588305" type:0];
    //[self barcodeData:@"788800" type:0];
}

- (IBAction)requestDiscountsAction:(id)sender
{
    if (self.items.count < 1)
    {
        [self showInfoMessage:@"Необходимо добавить хотя бы один товар"];
        return;
    }
    
    [_footerActivity startAnimating];
    _nextButton.enabled     = NO;
    _clearButton.enabled    = NO;
    [[MCPServer instance] discounts:self receiptId:_currentReceiptId];
}

- (void) openShift:(NSDate* ) date
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Пожалуйста, подождите" message:@"Происходит открытие дня..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
    _openShiftPlaceholder = alert;
    [[MCPServer instance] openShift:self date:date];
}

- (void) cartAddHandler:(NSNotification*) aNotification
{
    [super cartAddHandler:aNotification];
    
    //Rivgosh hack
    
    ItemInformation *itemInfo = [aNotification.userInfo objectForKey:@"item"];
    ParameterInformation *uidParam = nil;
    for (ParameterInformation *currentParam in itemInfo.additionalParameters) {
        if ([currentParam.name isEqualToString:@"uid"])
        {
            uidParam = currentParam;
            break;
        }
    }
    
    if (uidParam && [self.itemsCount objectForKey:itemInfo.barcode])
    {
        if ([self isUniqueItem:uidParam.value])
        {
            [self.items addObject:itemInfo];
            [self.itemsCount setObject:[NSNumber numberWithInteger:1] forKey:itemInfo.barcode];
        }
    }
    
    [self.tableView reloadData];
    [self updateTotal];
    
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: numberOfRows-1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: NO];
}

- (BOOL) isUniqueItem:(NSString*) uid
{
    BOOL unique = YES;
    
    for (ItemInformation* currentItem in self.items) {
        for (ParameterInformation *currentParam in currentItem.additionalParameters) {
            if ([currentParam.name isEqualToString:@"uid"] && [currentParam.value isEqualToString:uid])
            {
                unique = NO;
                break;
            }
            
            if (!unique)
                break;
        }
    }
    
    return unique;
}

#pragma mark - Network Delegate

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    requestInProgress = NO;
    
    if (result == 0 && itemDescription)
    {
        NSDictionary *userInfo = @{@"item":itemDescription};
        NSNotification *notification = [[NSNotification alloc] initWithName:@"CartAddMessage" object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        if (itemDescription.additionalParameters.count > 0)
        {
            ParameterInformation*param = nil;
            for (ParameterInformation* currentParam in itemDescription.additionalParameters) {
                if ([currentParam.name isEqualToString:@"ReceiptID"])
                    param = currentParam;
            }
            if (param)
                self.currentReceiptId = param.value;
        }
        //if (![itemDescription.barcode isEqualToString:@"788800"])
        //    [self barcodeData:@"788800" type:0];
    }
    else if (result == 500)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не открыт кассовый день. Хотите открыть?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да",nil];
        alert.tag = 10;
        [alert show];
    }
    else
    {
        NSString* errorDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkErrorDescription"];
        NSString* message = errorDescription?errorDescription:@"Не удалось добавить товар";
        [self showInfoMessage:message];
    }
}

- (void) clientCardComplete:(int)result description:(NSString *)description hint:(NSString *)hint receiptID:(NSString *)receiptID
{
    requestInProgress = NO;
    [_headerActivity stopAnimating];
    
    if (result == 0)
    {
        _nameLabel.text = description;
        
        if (hint.length > 0)
            [self showInfoMessage:hint];
        self.currentReceiptId = receiptID;
    }
    else if (result == 500)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не открыт кассовый день. Хотите открыть?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да",nil];
        alert.tag = 10;
        [alert show];
    }
    else
    {
        NSString* errorDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkErrorDescription"];
        NSString* message = errorDescription?errorDescription:@"Карта не найдена в системе";
        [self showInfoMessage:message];
    }
}

- (void) discountsComplete:(int)result discounts:(NSArray<DiscountInformation *>*)discounts
{
    if (result == 0)
    {
        self.discountArray = [self filteredDiscountsArray:discounts];
        
        if (_discountArray.count > 0)
        {
            [_footerActivity stopAnimating];
            _nextButton.enabled = YES;
            _clearButton.enabled = YES;
            [self performSegueWithIdentifier:@"DiscountSegue" sender:nil];
        }
        else
            [[MCPServer instance] applyDiscounts:self discounts:nil receiptId:_currentReceiptId];
    }
    else
    {
        [_footerActivity stopAnimating];
        _nextButton.enabled = YES;
        _clearButton.enabled = YES;
        NSString* errorDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkErrorDescription"];
        NSString* message = errorDescription?errorDescription:@"Не удалось получить скидки. Попробуйте снова";
        [self showInfoMessage:message];
    }
}

- (void) applyDiscountsComplete:(int)result items:(NSArray *)items
{
    [_footerActivity stopAnimating];
    _nextButton.enabled = YES;
    _clearButton.enabled = YES;
    
    if (result == 0)
    {
        [self performSegueWithIdentifier:@"PreviewThroughSegue" sender:items];
    }
    else
    {
        [self showInfoMessage:@"Не удалось получить скидки. Попробуйте снова"];
    }
}

- (NSArray*) filteredDiscountsArray:(NSArray*) discounts
{
    NSMutableArray *filteredDiscounts = [NSMutableArray new];
    for (DiscountInformation* discount in discounts) {
        if (discount.discountAmountRub != 0.0)
            [filteredDiscounts addObject:discount];
    }
    
    return filteredDiscounts;
}

- (void) showInfoMessage:(NSString*) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
}

- (IBAction)clearCartAction:(id)sender
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Вы действительно хотите очистить корзину?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да",nil];
    alert.tag = 0;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
        return;
    
    if (alertView.tag == 1)
    {
        [self barcodeData:[alertView textFieldAtIndex:0].text type:0];
    }
    else if (alertView.tag == 10)
    {
        [self openShift:[NSDate date]];
    }
    else
    {
        _nameLabel.text = @"5550012345678\n(Системная карта)";
        self.currentReceiptId = nil;
        [self.items removeAllObjects];
        [self.itemsCount removeAllObjects];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateTotal];
    }
}

- (void) openShiftComplete:(int)result
{
    [_openShiftPlaceholder dismissWithClickedButtonIndex:-1 animated:YES];
    
    if (result == 0)
    {
    }
    else
    {
        [self showInfoMessage:@"Не удалось открыть день"];
    }
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     
     if ([segue.identifier isEqualToString:@"DiscountSegue"])
     {
         DiscountsViewController *discounts = segue.destinationViewController;
         CGFloat totalAmount = 0.0f;
         for (ItemInformation* itemInfo in self.items) {
             NSInteger itemQuantity = [[self.itemsCount objectForKey:itemInfo.barcode] integerValue];
             totalAmount += itemInfo.price*itemQuantity;
         }
     
         discounts.discounts = _discountArray;
         discounts.amount = totalAmount;
         discounts.receiptID = _currentReceiptId;
     }
     else
     {
         PreviewViewController *previewVC = segue.destinationViewController;
         previewVC.items = sender;
         previewVC.receiptID = _currentReceiptId;
     }
 }

@end

