//
//  MoebiusPrinterManager.m
//  BluetoothPrinterSDK
//
//  Created by Denis Kurochkin on 15/10/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import "MoebiusPrinterManager.h"
#import "MoebiusKKM.h"
#import "StreamBridge.hpp"
#import "MoebiusPrinter_C_Interface.h"
#import "DTDevices.h"

@implementation PrintItem

- (void) dealloc
{
 
}

@end

@interface MoebiusPrinterManager () <NSStreamDelegate>
{
    CMoebiusKKM *moebius;
    StreamBridge*bridge;
    NSMutableData *_incomingData;
    NSInteger _bytesRead;
    BOOL _errorOccuredDuringRead;
    
}

@end

@implementation MoebiusPrinterManager

static int firstBlockLength = 18;

bool writeBytes (void *object, unsigned char *buffer, int bufferSize)
{
    return [(__bridge id)object writeBytes:buffer size:bufferSize];
}

bool readBytes  (void *object, unsigned char *buffer, int * pLenIncBuffer, int timeout, bool &bwastimeout)
{
    return [(__bridge id)object readBytes:buffer incomingSize:pLenIncBuffer timeout:timeout hasOccured:bwastimeout];
};

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _bytesRead = 0;
        _errorOccuredDuringRead = NO;
        
        
        moebius = new CMoebiusKKM();
        bridge = new StreamBridge((__bridge void*)(self));
        bool result = moebius -> InitAppleSDK(bridge);
    }
    
    return self;
}

- (void) dealloc
{
    delete moebius;
    delete bridge;
}


#pragma Stream Bridge Methods

- (BOOL) writeBytes: (unsigned char *)buffer size: (int) bufferSize
{
    DTDevices *dtDevice = [DTDevices sharedDevice];
    NSError *writeError = nil;
    
    
    //NSInputStream *inputStream = [dtDevice btInputStream];
    //inputStream.delegate = self;
    //[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //[inputStream open];
    
    _bytesRead = 0;
    [_incomingData setLength:0];
    
    [dtDevice btWrite:buffer length:bufferSize error:&writeError];
    
    NSLog(@"Interface write bytes: \'%s\' size: %d bytes errorOccured: %@", buffer, bufferSize, (writeError == nil)?@"NO":@"YES");
    
    if (writeError)
        return NO;
    else
        return YES;
};


- (BOOL) readBytes: (unsigned char *)buffer incomingSize:(int*) bufferSize timeout:(int)timeout hasOccured: (bool &) occured
{
    DTDevices *dtDevice = [DTDevices sharedDevice];
    NSError *readError = nil;
    unsigned char readData [1024];
    int readBufSize = [dtDevice btRead:readData length:1024 timeout:0.0 error:&readError];
    
    NSLog(@"Interface read bytes: \'%s\' size: %d bytes errorOccured: %@", readData, readBufSize, (readError == nil)?@"NO":@"YES");
    
    if (readError)
        return NO;
    else
    {
        *bufferSize = readBufSize;
        for (int i = 0; i < readBufSize; ++ i)
        {
            buffer[i] = readData[i];
        }
    }
    
    return YES;
    
    /*if (_errorOccuredDuringRead)
    {
        _errorOccuredDuringRead = NO;
        return NO;
    }
    
    if (_bytesRead > 0)
    {
        unsigned char* readData = (unsigned char*)[_incomingData bytes];
        for (int i = 0; i < _bytesRead; ++ i)
        {
            buffer[i] = readData[i];
        }
        *bufferSize = (int)_bytesRead;
        
        _bytesRead = 0;
        _incomingData.length = 0;
    }
    
    return YES; */
}

#pragma mark - NSInputStream delegate

- (void) showAlertWithMessage:(NSString*) message
{

}
            // continued

#pragma mark - Interface Methods

- (NSInteger) printCommonData
{
    // Ведомость общих показаний
    
    BYTE result = moebius -> KkmGetCommonData(0);
    
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
    
}

- (NSInteger) openShift:(NSString *)name
{
    // Открытие смены
    
    Date currentDate;
    [self currentDataStruct:&currentDate];
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    const char*cString = [name cStringUsingEncoding:encoding];
    
    BYTE result = moebius -> KkmOpenShift(&currentDate, (BYTE)4, (char*)cString);
    
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
}

- (NSInteger) mbsPut
{
    // Внесение в кассу
    
    BYTE result = moebius -> mbs_put((int)111, (int)123, (int)123, (BYTE)1, false, false, (char*)"", (char*)"", (BYTE)1, false, true);
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
}

- (BOOL) isShiftOpen
{
    BYTE currentShift = moebius->KkmGetShiftInfo();
   /* const unsigned char cmd[] =
    {
        currentShift
    };
    NSData *data = [NSData dataWithBytes:cmd length:1];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* strinToshow = [NSString stringWithFormat:@"%@", data];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Смена" message:strinToshow delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }); */
    
    return (currentShift == 0);
}

- (NSInteger) mbsReceipt
{
    //Кассовый чек
    // Переводит регистратор в режим формирования чека и печатает его заголовок
    BYTE result = moebius -> mbs_head((BYTE)1, (BYTE)1, (char*)"0");
    [self showErrorAlert:result];
    if (result) return result;
    
    // Формирования товарной позиции
    NSString *item1 = @"Товар 1";
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    const char*cString = [item1 cStringUsingEncoding:encoding];
    result = moebius->mbs_RecItem((char*)cString, (char*)"0123456789", (char*)"1", (int)111, (int)1, (int)111, (int)0, false, (char*)"");
    [self showErrorAlert:result];
    if (result) return result;
    
    // Под итог чека
    result = moebius->mbs_Subtotal((int)111);
    [self showErrorAlert:result];
    if (result) return result;
    
    // Итог чека
    PaymentSt cardPay [16];
    PaymentSt creditPay [16];
    
    for (int i = 0; i < 16; i++)
    {
        strcpy(cardPay[i].Name, "aaa");
        strcpy(cardPay[i].Num, "bbb");
        cardPay[i].Sum = (DWORD)0;
        
        strcpy(creditPay[i].Name, "aaa");
        strcpy(creditPay[i].Num, "bbb");
        creditPay[i].Sum = (DWORD)0;
    }
    
    NSString *item2 = @"Трейлер";
    cString = [item2 cStringUsingEncoding:encoding];
    result = moebius->mbs_tot((int)111, (int)500, (int)611, cardPay, creditPay, (char*)cString, (int)1, (int)1);
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
}


- (NSInteger) mbsReturnReceipt
{
    //Чек возврата
    // Переводит регистратор в режим формирования чека и печатает его заголовок
    BYTE result = moebius -> mbs_head(((BYTE)1 | 0x80), (BYTE)1, (char*)"0");
    [self showErrorAlert:result];
    if (result) return result;
    
    // Формирования товарной позиции
    NSString *item1 = @"Товар 1";
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    const char*cString = [item1 cStringUsingEncoding:encoding];
    result = moebius->mbs_RecItem((char*)cString, (char*)"0123456789", (char*)"1", (int)111, (int)1, (int)111, (int)0, false, (char*)"");
    [self showErrorAlert:result];
    if (result) return result;
    
    // Под итог чека
    result = moebius->mbs_Subtotal((int)111);
    [self showErrorAlert:result];
    if (result) return result;
    
    // Итог чека
    PaymentSt cardPay [16];
    PaymentSt creditPay [16];
    
    for (int i = 0; i < 16; i++)
    {
        strcpy(cardPay[i].Name, "aaa");
        strcpy(cardPay[i].Num, "bbb");
        cardPay[i].Sum = (DWORD)0;
        
        strcpy(creditPay[i].Name, "aaa");
        strcpy(creditPay[i].Num, "bbb");
        creditPay[i].Sum = (DWORD)0;
    }
    
    NSString *item2 = @"Трейлер";
    cString = [item2 cStringUsingEncoding:encoding];
    result = moebius->mbs_tot((int)111, (int)500, (int)611, cardPay, creditPay, (char*)cString, (int)1, (int)1);
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
}

#warning "SAMPLE!"

- (NSInteger) sampleReceipt:(double)amount
{
    
    //Пример сложного чека
    // Переводит регистратор в режим формирования чека и печатает его заголовок
    amount = amount*100;
    BYTE result = moebius -> mbs_head((BYTE)1, (BYTE)1, (char*)"0");
    [self showErrorAlert:result];
    if (result) return result;
    
    // Формирования товарной позиции
    NSString *item1 = @"Продажа";
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    const char*cString = [item1 cStringUsingEncoding:encoding];
    
    NSString *suffix = @"шт.";
    const char*cStringSuffix = [suffix cStringUsingEncoding:encoding];
    
    result = moebius->mbs_RecItem((char*)cString, (char*)"28517", (char*)"1", (int)amount, (int)2, (int)amount/2, (int)0, false, (char*)cStringSuffix);
    [self showErrorAlert:result];
    if (result) return result;
    
    //[self textBetweenItems];
    //[self textBetweenItems];
    
    //result = moebius->mbs_RecItemAdjust(-2000, 4000, false, 0, (char*)"");
    //[self showErrorAlert:result];
    //if (result) return result;
    
    //[self textBetweenItems];
    //[self textBetweenItems];
    
    
    // Подитог чека
    //result = moebius->mbs_Subtotal((int)111);
    //[self showErrorAlert:result];
    //if (result) return result;
    
   // [self addPlainText:@"--------------------------------------------"];
   // [self addItemRecString:@"Ножницы Deglon для разделки птицы 5258024-С" count:1 identifier:@"59977" price:10 discount:0];
   // [self addItemRecString:@"Ножницы Kai BK-0202" count:1 identifier:@"46442" price:10 discount:0];
    
    
    // Итог чека
    PaymentSt cardPay [16];
    PaymentSt creditPay [16];
    
    CGFloat cardAmount = [[NSUserDefaults standardUserDefaults] floatForKey:@"PrinterCardAmount"];
    CGFloat cashAmount = MAX(0, amount-cardAmount*100);
    
    for (int i = 0; i < 16; i++)
    {
        if (i == 0)
        {
            strcpy(cardPay[i].Name, "aaa");
            strcpy(cardPay[i].Num, "1234123412341234");
            cardPay[i].Sum = cardAmount*100;
            
            strcpy(creditPay[i].Name, "creditName");
            strcpy(creditPay[i].Num, "bbb");
            creditPay[i].Sum = 0;
        }
        else
        {
            
            
            strcpy(cardPay[i].Name, "aaa");
            strcpy(cardPay[i].Num, "bbb");
            cardPay[i].Sum = (DWORD)0;
            
            strcpy(creditPay[i].Name, "aaa");
            strcpy(creditPay[i].Num, "bbb");
            creditPay[i].Sum = (DWORD)0;
        }
    }
    
    NSString *item2 = @"";
    cString = [item2 cStringUsingEncoding:encoding];
    result = moebius->mbs_tot((int)amount, (int)0, (int)cashAmount, cardPay, creditPay, (char*)cString, (int)1, (int)1);
    [self showErrorAlert:result];
    
    
    //[self addBonusSnippet];
    
    //[self addTrailerText:@"\r\n      Товар получен, работоспособность"];
    //[self addTrailerText:@"         и комплектация проверены."];
    //[self addTrailerText:@"Информация о товаре и всех приобретенных"];
    //[self addTrailerText:@" услугах предоставлена в полном объеме."];
    //[self addTrailerText:@"            Претензий не имею.\r\n"];
    //[self addTrailerText:@"Подпись покупателя:\r\n\r\n"];
    //[self addSignatureField];
    //[self addTrailerText:@"\n\r\n\rГорячая линия:             8-800-100-55-88"];
    //[self addTrailerText:@"E-mail:              hotline@technopark.ru"];
    
    
    
    [self finalizeCommandWithResult];
    
    return result;
}




- (NSInteger) realReceipt:(NSArray<PrintItem*>*)items footer:(NSString *)footer orderAmount:(double)orderAmount giftAmount:(double)giftAmount shouldPrintVarFooter:(BOOL)varFooter
{    
    double total            = 0;
    double totalNoDiscount  = 0;
    double cashAmount       = 0;
    double itemsAmount      = 0;
    double discountAmount   = 0;
    int itemsCount          = 0;
    
    
    for (PrintItem *item in items) {
        itemsAmount     +=  MAX((item.price - item.discount),0);
        totalNoDiscount +=  item.price;
        itemsCount      +=  item.quantiny;
        discountAmount  +=  item.discount;
    }
    itemsAmount = itemsAmount*100;
    cashAmount  = (orderAmount >= 0) ? MAX(0, orderAmount - giftAmount)*100:MAX(0, itemsAmount - giftAmount*100);
    total       =  (orderAmount >= 0) ?  orderAmount*100:itemsAmount;
    if (cashAmount == 0)
        giftAmount = (orderAmount >= 0) ? orderAmount:itemsAmount/100;
    
    //Пример сложного чека
    // Переводит регистратор в режим формирования чека и печатает его заголовок
    BYTE result = moebius -> mbs_head((BYTE)1, (BYTE)1, (char*)"0");
    [self showErrorAlert:result];
    if (result) return result;
    
    {
        //Printing fiscal header info:
        NSArray *topFooter = [self topFooter:footer];
        if (topFooter.count > 0)
            [self printHeaderTechnopark:topFooter];
    }
    
    // Формирования товарной позиции
    NSString *item1 = @"Продажа";
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    const char*cString = [item1 cStringUsingEncoding:encoding];
    NSString *item22 = @"Взнос";
    const char*cString1 = [item22 cStringUsingEncoding:encoding];
    NSString *suffix = @"шт.";
    const char*cStringSuffix = [suffix cStringUsingEncoding:encoding];
    
    
    if (orderAmount < 0)
        result = moebius->mbs_RecItem((char*)cString, (char*)"28517", (char*)"1", (int)totalNoDiscount*100, (int)1, (int)totalNoDiscount*100, (int)0, false, (char*)cStringSuffix);
    else
    {
        [self addInitialPayment:totalNoDiscount];
        result = moebius->mbs_RecItem((char*)cString1, (char*)"", (char*)"1", (int)orderAmount*100, (int)1, (int)orderAmount*100, (int)0, false, (char*)cStringSuffix);
    }

    [self showErrorAlert:result];
    if (result) return result;

    [self addPlainText:@"--------------------------------------------"];
    
    for (PrintItem *item in items) {
        [self addItemRecString:item.name count:item.quantiny identifier:item.itemCode price:item.price discount:item.discount];
    }

    
    // Итог чека
    PaymentSt cardPay [16];
    PaymentSt creditPay [16];
    CGFloat cardAmount = [[NSUserDefaults standardUserDefaults] floatForKey:@"PrinterCardAmount"];
    cashAmount = MAX(0, cashAmount-cardAmount*100);
    
    for (int i = 0; i < 16; i++)
    {
        if (i == 0)
        {
            strcpy(cardPay[i].Name, "aaa");
            strcpy(cardPay[i].Num, "1234123412341234");
            cardPay[i].Sum = cardAmount*100;;
            
            strcpy(creditPay[i].Name, "creditName\r\n");
            strcpy(creditPay[i].Num, "bbb\r\n");
            creditPay[i].Sum = giftAmount*100;
        }
        else
        {
        
        
        strcpy(cardPay[i].Name, "aaa");
        strcpy(cardPay[i].Num, "bbb");
        cardPay[i].Sum = (DWORD)0;
        
        strcpy(creditPay[i].Name, "aaa");
        strcpy(creditPay[i].Num, "bbb");
        creditPay[i].Sum = (DWORD)0;
        }
    }
    
    NSString *item2 = @"";
    cString = [item2 cStringUsingEncoding:encoding];
    
    /*dispatch_async(dispatch_get_main_queue(), ^{
        NSString *stringToShow = [NSString stringWithFormat:@"total = %.2f, cash = %.2f, gift = %.2f", total, cashAmount, giftAmount*100];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:stringToShow delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });*/
   
    
    if (discountAmount>0 && orderAmount < 0)
    {
        if (discountAmount > totalNoDiscount)
            discountAmount = totalNoDiscount;
        
        result = moebius->mbs_adjust_sum(false, -discountAmount*100, total, false, false, 0, -discountAmount*100);
        [self showErrorAlert:result];
    }
    result = moebius->mbs_tot(total, (int)0, cashAmount, cardPay, creditPay, (char*)cString, (int)1, (int)1);

    //if (giftAmount > 0)
    //    [self addTrailerText:];
    
    [self showErrorAlert:result];
    
    {
        //Printing fiscal footer info:
        NSArray *bottomFooter = [self bottomFooter:footer];
        if (bottomFooter.count > 0)
            [self printFooterTechnopark:bottomFooter];
    }
    
    if (varFooter)
    {
        //Printing variable footer info:
        NSArray *bottomFooter = [self varFooter:footer];
        if (bottomFooter.count > 0)
            [self printFooterTechnopark:bottomFooter];
    }
    {
        //Printing constant footer info:
        NSArray *bottomFooter = [self constFooter:footer];
        if (bottomFooter.count > 0)
            [self printFooterTechnopark:bottomFooter];
    }
    
    [self finalizeCommandWithResult];
    
    return result;
}


- (void) printHeaderTechnopark:(NSArray*) header
{
    for (int i = 0; i < header.count; ++i)
    {
        [self addPlainText:header[i]];
    }
}

- (void) printFooterTechnopark:(NSArray*) footer
{
    for (int i = 0; i < footer.count; ++i)
    {
        [self addTrailerText:footer[i]];
    }
}

- (NSInteger) mbsOut
{
    // Выплата из кассы
    BYTE result = moebius -> mbs_put((int)111, (int)123, (int)123, (BYTE)2, false, false, (char*)"", (char*)"", (BYTE)1, false, true);
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
}

- (NSInteger) xReport
{
    BYTE result = moebius -> KkmGetShiftData((BYTE)0);
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
}

- (NSInteger) zReport
{
    Date currentDate;
    [self currentDataStruct:&currentDate];
    
    BYTE result = moebius -> KkmCloseShift(&currentDate, (BYTE)0xC0);
    [self showErrorAlert:result];
    [self finalizeCommandWithResult];
    
    return result;
}

#pragma mark - Helper Functions

- (void) showErrorAlert:(BYTE) result;
{
    //unsigned char data[] = {result};
    //NSData *resultData = [[NSData alloc] initWithBytes:data length:1];

    if (!result)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:[self errorLocalizedDescription:result] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}

- (NSString*) errorLocalizedDescription:(BYTE) result
{
    NSString* description = nil;
    switch (result) {
        case 19:
            description = @"Смена уже открыта";
            break;
        case 20:
            description = @"Смена не открыта. Сначала откройте смену в разделе \"оборудование\"";
            break;
            
        default:
            description = @"Произошла неизвестная ошибка. Попробуйте снова.";
            break;
    }
    
    return description;
}

- (void) finalizeCommandWithResult
{
    
    if (_delegate)
        [_delegate moebiusPrinterDidFinishPrinting:self];
}

- (void) currentDataStruct:(Date*) date
{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay |
                           NSCalendarUnitYear |
                           NSCalendarUnitMonth |
                           NSCalendarUnitHour |
                           NSCalendarUnitMinute |
                           NSCalendarUnitSecond) fromDate:today];
    
    
    date->Year    = (short)weekdayComponents.year;
    date->Month   = (UInt8)weekdayComponents.month;
    date->Day     = (UInt8)weekdayComponents.day;
    date->Hour    = (UInt8)weekdayComponents.hour;
    date->Min     = (UInt8)weekdayComponents.minute;
    date->Sec     = (UInt8)weekdayComponents.second;
}

#pragma mark - Custom Receipt Functions

- (void) addInitialPayment:(CGFloat) price
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    
    //Formatting amount
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @"'";
    formatter.decimalSeparator = @".";
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    
    NSString *formattedAmount   = [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
    NSString *spacesString      = [self spaceString:44 - (firstBlockLength + formattedAmount.length)];
    
    NSString *clientCard = [NSString stringWithFormat:@"Продажа       1 шт%@%@", spacesString, formattedAmount];
    
    const char* cString = [clientCard cStringUsingEncoding:encoding];
    //BYTE result = moebius -> KkmSendTextBlock((char*)cString, (int)clientCard.length);
    BYTE result = moebius -> Prn_tpm_write(8, (char*)cString, (int)clientCard.length);
    [self showErrorAlert:result];
}

- (void) addItemRecString: (NSString*) itemDescrition count:(int) count identifier:(NSString*) identifier price:(CGFloat) price discount: (CGFloat) discount
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    
    //Formatting amount
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.groupingSeparator = @"'";
    formatter.decimalSeparator = @".";
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    
    NSString *formattedAmount   = [formatter stringFromNumber:[NSNumber numberWithFloat:price]];
    NSString *formattedDiscount = [formatter stringFromNumber:[NSNumber numberWithFloat:discount]];
    NSString *formattedTotal    = [formatter stringFromNumber:[NSNumber numberWithFloat:MAX((price-discount), 0)]];
    NSString *countString       = [NSString stringWithFormat:@"%d шт", count];
    NSString *firstSpacesString       = [self spaceString:firstBlockLength - (identifier.length + countString.length)];
    NSString *secondSpacesString      = [self spaceString:44 - (firstBlockLength + formattedAmount.length)];
    
    NSString *clientCard = [NSString stringWithFormat:@"%@\n\n%@%@%@%@%@", itemDescrition, identifier,firstSpacesString, countString, secondSpacesString, formattedAmount];
    NSMutableString *mutablePosition = [[NSMutableString alloc] initWithString:clientCard];
    if (discount > 0)
    {
        NSString* bonusSpacesString = [self spaceString:44 - (13 + formattedDiscount.length)];
        NSString* totalSpacesString = [self spaceString:44 - (15 + formattedTotal.length)];
        [mutablePosition appendFormat:@"\nСкидка по БК:%@%@",bonusSpacesString,formattedDiscount];
        [mutablePosition appendFormat:@"\nСумма к оплате:%@%@",totalSpacesString,formattedTotal];
        
    }
    [mutablePosition appendFormat:@"\n--------------------------------------------"];
    
    
    const char* cString = [mutablePosition cStringUsingEncoding:encoding];
    //BYTE result = moebius -> KkmSendTextBlock((char*)cString, (int)clientCard.length);
    BYTE result = moebius -> Prn_tpm_write(8, (char*)cString, (int)mutablePosition.length);
    [self showErrorAlert:result];
    
    //[self finalizeCommandWithResult];
}

- (NSString*) spaceString: (NSInteger) numberOfSpaces
{
    NSMutableString *spacesString = [NSMutableString stringWithCapacity: numberOfSpaces];
    for (int i = 0; i < numberOfSpaces;++i)
        [spacesString appendString:@" "];
    return spacesString;
}

- (void) addPlainText:(NSString*) text
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSRussian);
    
    NSString *clientCard = text;
    const char* cString = [clientCard cStringUsingEncoding:encoding];
    //BYTE result = moebius -> KkmSendTextBlock((char*)cString, (int)clientCard.length);
    BYTE result = moebius -> Prn_tpm_write(8, (char*)cString, (int)clientCard.length);
    [self showErrorAlert:result];
    
    //[self finalizeCommandWithResult];
}

- (void) addTrailerText:(NSString*) text
{
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsCyrillic);
    
    NSMutableString *textToPrint = [[NSMutableString alloc] initWithString:text];
    [textToPrint appendFormat:@"\r\n"];
    
    const char* cString = [textToPrint cStringUsingEncoding:encoding];

    BYTE result = moebius -> KkmSendTextBlock((char*)cString, (int)textToPrint.length);
    [self showErrorAlert:result];
    
    textToPrint = nil;
    
    //[self finalizeCommandWithResult];
}

#pragma mark - Technopark stuff

- (void) addTextInsideFiscal:(NSString*)text
{
    NSString *toFind = [NSString stringWithCString:"\r\n" encoding:NSUTF8StringEncoding];
    NSArray *footerComponents = [text componentsSeparatedByString:toFind];
    
    for (int i = 0; i < footerComponents.count; ++i)
    {
        [self addPlainText:footerComponents[i]];
    }
}

- (void) addBonusSnippet
{
    [self addTrailerText:@"      ********************************"];
    [self addTrailerText:@"      *- Использовать Бонусы могут   *"];
    [self addTrailerText:@"      *  только зарегестрированные   *"];
    [self addTrailerText:@"      *  владельцы карт              *"];
    [self addTrailerText:@"      *- Срок действия начисленных   *"];
    [self addTrailerText:@"      *  Бонусов составляет 180 дней *"];
    [self addTrailerText:@"      *- Начисленными Бонусами можно *"];
    [self addTrailerText:@"      *  оплатить до 100% стоимости  *"];
    [self addTrailerText:@"      *  товара                      *"];
    [self addTrailerText:@"      *- Все Бонусы с карты списыва- *"];
    [self addTrailerText:@"      *  ются единовременно          *"];
    [self addTrailerText:@"      *  1 Бонус = 1 Рубль           *"];
    [self addTrailerText:@"      ********************************"];
}

- (void) addSignatureField
{
    const unsigned char s[] = {0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97,0x97, 0x0d, 0x0a};
    
    BYTE result = moebius -> KkmSendTextBlock((char*)s, sizeof(s));
    [self showErrorAlert:result];
}

#pragma mark - Footer parsing Technopark

- (NSArray*) topFooter:(NSString*) json
{
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    id obj = [parsedObject objectForKey:@"top_footer"];
    if (obj && [obj isKindOfClass:[NSArray class]])
        return obj;
    else
        return nil;
}

- (NSArray*) bottomFooter:(NSString*) json
{
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    id obj = [parsedObject objectForKey:@"bottom_footer"];
    if (obj && [obj isKindOfClass:[NSArray class]])
        return obj;
    else
        return nil;
}

- (NSArray*) varFooter:(NSString*) json
{
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    id obj = [parsedObject objectForKey:@"var_footer"];
    if (obj && [obj isKindOfClass:[NSArray class]])
        return obj;
    else
        return nil;
}

- (NSArray*) constFooter:(NSString*) json
{
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    id obj = [parsedObject objectForKey:@"const_footer"];
    if (obj && [obj isKindOfClass:[NSArray class]])
        return obj;
    else
        return nil;
}


@end
