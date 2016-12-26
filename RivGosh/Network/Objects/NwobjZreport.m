//
//  NwobjZreport.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjZreport.h"
#import "Logger.h"

@implementation NwobjZreport

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

- (void) setDelegate:(id<PrinterDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(PrinterDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        _delegate = delegate;
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
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
    NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@/zreport/%@/",url, uuid];
    if (_receiptID)
        [urlString appendFormat:@"?id=%@", _receiptID];
    else if (_amount)
    {
        [urlString appendFormat:@"?sum=%f", _amount.doubleValue];
    }
    
    nwReq.URL = urlString;
    //#endif
    nwReq.httpMethod = _amount?HTTP_METHOD_POST:HTTP_METHOD_GET;
    
    //[nwReq addParam:@"value" withValue:string];
    //[nwReq addParam:@"password" withValue:[_userPassword sha256]];
#if TARGET_IPHONE_SIMULATOR
    //[nwReq addParam:@"device_id" withValue:@"123456789Simulator"];
    //running on device
#else
    //[nwReq addParam:@"device_id" withValue:[UIDevice currentDevice].identifierForVendor.UUIDString];
#endif
    
    
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
    ZReport* report = nil;
    
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
            report = [ZReport new];
            
            id obj = [result objectForKey:@"data"];
            if (obj && [obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* data = obj;
                obj = [data objectForKey:@"Оплаты"];
                if (obj && [obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *payments = obj;
                    obj = [payments objectForKey:@"id"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        report.receiptID = obj;
                    obj = [payments objectForKey:@"BD"];
                    if (obj && [obj isKindOfClass:[NSArray class]] && [obj count] > 0)
                    {
                        NSDictionary* bd = obj[0];
                        obj = [bd objectForKey:@"Сумма"];
                        if (obj && [obj isKindOfClass:[NSNumber class]])
                            report.dbAmount = obj;
                        obj = [bd objectForKey:@"СуммаФР"];
                        if (obj && [obj isKindOfClass:[NSNumber class]])
                            report.fiscalAmount = obj;
                    }
                    
                }
                
                obj = [data objectForKey:@"ОтрицОстатки"];
                if (obj && [obj isKindOfClass:[NSArray class]])
                    report.items = obj;
            }
        }
        else
        {
            id obj = [result objectForKey:@"data"];
            if (obj && [obj isKindOfClass:[NSString class]])
                [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"NetworkErrorDescription"];
            else
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"NetworkErrorDescription"];
            
        }
        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate && [_delegate respondsToSelector:@selector(zReportComplete:zReport:reqID:)])
        [_delegate zReportComplete:_resultCode zReport:report reqID:_reqID];
}

@end
