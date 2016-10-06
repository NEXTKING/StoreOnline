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
    
    NSString *slipString = nil;
    
    slipString = [NSString stringWithFormat:
                  @"        Газпромбанк\n"
                  "14.02.16\n"
                  "14:16\n"
                  "ЧЕК\n"
                  "Оплата\n"
                  "Номер операции:       %@\n"
                  "Терминал:               00595152\n"
                  "Пункт обслуживания: 550000008153\n"
                  "Visa Electron  A0000000032010\n"
                  "Карта:(C)       %@\n"
                  "Клиент:        SHAVEINIKOVA/ANNA\n"
                  "\n"
                  "Сумма (Руб):\n"
                  "2000.00\n"
                  "Комиссия за операцию - 0 руб.\n"
                  "ОДОБРЕНО\n"
                  "Код авторизации:          %@\n"
                  "\n"
                  "Номер ссылки:       604583437541\n"
                  "Введен ПИН-код\n"
                  "\n"
                  "\n"
                  "\n"
                  "__________________________\n"
                  "подп.кассира(контролера)\n"
                  "2DB4FF75BA5C414F773AC9EA2B0F6786\n"
                  "================================", _transactionCode, _card, _authCode];
    
    [finalMutable appendString:slipString];
    [finalMutable appendString:@"[cut]"];
    [finalMutable appendString:slipString];
    
    
    
    NSLog(@"%@", finalMutable);
    
    return finalMutable;
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
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/pay/%@/?id=%@&sum=%@&auth_code=%@&tran_code=%@&card=%@",url,uuid, _receiptID, [NSString stringWithFormat:@"%.2f", _amount], _authCode, _transactionCode, _card];
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
