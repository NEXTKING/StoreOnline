//
//  NwobjSendPayment.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 01.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjSendPayment.h"
#import "Logger.h"

@implementation NwobjSendPayment

static int receiptWidth = 36;

- (id)init
{
    self = [super init];
    if (self)
    {
        _resultCode = -1;
        self.accessToken = @"";
        self.userId = @"";
        _delegate = nil;
    }
    return self;
}

- (void)dealloc
{
}

- (void) setDelegate:(id<SendPaymentDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(SendPaymentDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        _delegate = delegate;
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (NSString*) generateSlip
{
    NSMutableString * finalMutable = [[NSMutableString alloc] init];
    
    NSMutableString *slipString = [[NSMutableString alloc] init];
    NSString *amountString = [NSString stringWithFormat:@"%.2f", _amount];
    NSString *bin = [_card substringToIndex:1];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter *timeForatter = [NSDateFormatter new];
    timeForatter.dateStyle = NSDateFormatterNoStyle;
    timeForatter.timeStyle = NSDateFormatterMediumStyle;
    NSString *time = [timeForatter stringFromDate:[NSDate date]];
    
    NSString *ips;
    switch (bin.integerValue) {
        case 4:
            ips = @"VISA";
            break;
        case 5:
            ips = @"MASTERCARD";
            break;
            
        default:
            ips = @"";
            break;
    }

    [slipString appendFormat:@"\n"];
    [slipString appendFormat:@"Терминал: %@\n", _terminalID];
    [slipString appendFormat:@"Чек %@\n", _receiptID];
    [slipString appendFormat:@"Мерчант: %@\n", _merchantID];
    [slipString appendFormat:@"%@\n", [self centeredValue:@"ОПЛАТА"]];
    [slipString appendFormat:@"%@\n", [self centeredValue:@"ОДОБРЕНО"]];
    [slipString appendFormat:@"%@\n", [self keyValueFormattedString:@"СУММА:" value:amountString]];
    [slipString appendFormat:@"РУБ\n"];
    [slipString appendFormat:@"%@\n", [self keyValueFormattedString:@"КОМИССИЯ Банка ГПБ (АО):" value:@"0.00"]];
    [slipString appendFormat:@"РУБ\n"];
    [slipString appendFormat:@"%@\n", [self keyValueFormattedString:@"ИТОГО:" value:amountString]];
    [slipString appendFormat:@"РУБ\n"];
    [slipString appendFormat:@"AID: %@\n", _aid];
    [slipString appendFormat:@"Карта: %@\n", ips];
    [slipString appendFormat:@"%@\n", [self centeredValue:_card]];
    [slipString appendFormat:@"%@\n", [self centeredValue:_cardholderName]];
    [slipString appendFormat:@"Код авториз.: %@ Код ответа:\n", _authCode];
    [slipString appendFormat:@"000\n"];
    [slipString appendFormat:@"Дата     %@\n", [dateFormatter stringFromDate:[NSDate date]]];
    [slipString appendFormat:@"                 ВРЕМЯ   :\n"];
    [slipString appendFormat:@"%@\n", time];
    [slipString appendFormat:@"Дата ПЦ  %@\n", [dateFormatter stringFromDate:[NSDate date]]];
    [slipString appendFormat:@"                 ВРЕМЯ ПЦ:\n"];
    [slipString appendFormat:@"%@\n", time];
    [slipString appendFormat:@"ВВЕДЕН OFFLINE-PIN\n"];
    [slipString appendFormat:@"=======================\n"];
    [slipString appendFormat:@"\n"];
    [slipString appendFormat:@"\n"];
    [slipString appendFormat:@"\n"];
    [slipString appendFormat:@"__________________________\n"];
    [slipString appendFormat:@"подпись клиента\n"];
    
    
    [finalMutable appendString:slipString];
    [finalMutable appendString:@"[cut]"];
    [finalMutable appendString:slipString];
    
    
    
    NSLog(@"%@", finalMutable);
    
    return finalMutable;
}

- (NSString* ) keyValueFormattedString:(NSString*) key value:(NSString*) value
{
    int length = key.length + value.length;
    int spaceNumber = receiptWidth - length;
    
    NSMutableString *mutable = [[NSMutableString alloc] init];
    [mutable appendString: key];
    [mutable appendFormat:@"%*s", spaceNumber,""];
    [mutable appendString: value];
    
    return mutable;
}

- (NSString*) centeredValue: (NSString*) value
{
    int spaceNumber = receiptWidth - value.length;
    NSMutableString *mutable = [[NSMutableString alloc] init];
    [mutable appendFormat:@"%*s", spaceNumber/2,""];
    [mutable appendString: value];
    
    return mutable;
}

- (void) run: (NSString*) url
{
    // Check input parameters:
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[NwRequest alloc] init];
    // NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:_cartData options:0 error:nil];
    //NSString *string = [[NSString alloc] initWithData:dataToSend encoding:NSUTF8StringEncoding];
    //#if RIVGOSH
    //
    //    nwReq.URL = [NSMutableString stringWithFormat:@"%@/client/?barcode=%@", url, _cardNumber ];
    //#else
    NSString* uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringToIndex:12];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/pay/%@/?id=%@&sum=%@&auth_code=%@&tran_code=%@&card=%@",url,uuid, _receiptID, [NSString stringWithFormat:@"%.2f", _amount], _authCode, _referenceNumber, _card];
    //#endif
    nwReq.httpMethod = HTTP_METHOD_POST;
    //[nwReq addParam:@"value" withValue:string];
    //[nwReq addParam:@"password" withValue:[_userPassword sha256]];
#if TARGET_IPHONE_SIMULATOR
    //[nwReq addParam:@"device_id" withValue:@"123456789Simulator"];
    //running on device
#else
    //[nwReq addParam:@"device_id" withValue:[UIDevice currentDevice].identifierForVendor.UUIDString];
#endif
    
    [nwReq setRawBody:[self generateSlip]];
    
    
    NSURLRequest *__exec_request = [nwReq buildURLRequest];
    
    //[__exec_request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    assert(__exec_request != nil);
    
    _exec_connection = [[NSURLConnection alloc] initWithRequest:__exec_request delegate:self];
    
    assert(_exec_connection != nil);
    
    [super run:Nil];    // enable network activity indicator
}

- (void) cancel
{
    [super cancel];     // disable network activity indicator
    
    if ( _exec_connection )
        [_exec_connection cancel];
    //if ( _delegate )
    //    [_delegate loginCancelled:_resultCode];
}

- (void) complete: (BOOL) isSuccessfull
{
    [super complete:isSuccessfull];     // disable network activity indicator
    
    _succeeded = isSuccessfull;
    NSDictionary *result = nil;
    
    _resultCode = -1;
    
    if ( _succeeded )
    {   // Request successfully performed
        NSString *dataString = [[NSString alloc] initWithData:_exec_data encoding:NSUTF8StringEncoding];
        [Logger log:self method:Nil format:@"TextRepres.: %@", dataString];
        
        // Process results
        // Handle Cookies
        
        /*if ( _cookies )
         {
         if ( [_cookies objectForKey:@"JSESSIONID"] != Nil )
         {
         if ( _accessToken )
         [_accessToken release];
         _accessToken = [[_cookies objectForKey:@"JSESSIONID"] copy];
         [Logger log:self method:@"complete" format:@"JSESSIONID=%@", _accessToken];
         }
         else
         {
         _resultCode = -1;
         [Logger log:self method:@"complete" format:@"'JSESSIONID' is not found"];
         }
         } */
        
        //Parse JSON
        result = [NSJSONSerialization JSONObjectWithData:_exec_data options:0 error:nil];
        
        if ( result )
        {
            if ( [result objectForKey:@"result"] != Nil )
            {
                _resultCode = [[result valueForKey:@"result"] intValue];
                [Logger log:self method:@"complete" format:@"result=%d", _resultCode];
            }
            else
            {
                _resultCode = -1;
                [Logger log:self method:@"complete" format:@"'result' is not found"];
            }
        }
        else
            _resultCode = -2;
        
        // id obj = nil;
        
        if ( _resultCode == 0 )
        {
            
        }
        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate sendPaymentComplete:_resultCode];
}


@end
