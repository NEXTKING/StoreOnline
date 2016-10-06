//
//  NwobjPrintStatus.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 01.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjPrintStatus.h"
#import "Logger.h"

@implementation NwobjPrintStatus

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
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/printstatus/?id=%@",url, _receiptID];
    //#endif
    nwReq.httpMethod = HTTP_METHOD_GET;
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
    
    _resultCode = -1;
    PrinterStatus* printerStatus = [PrinterStatus new];
    
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
            id obj = [result objectForKey:@"data"];
            if (obj && [obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *data = obj;
                obj = [data objectForKey:@"ServiceStatus"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    printerStatus.queueStatus  = [obj boolValue];
                obj = [data objectForKey:@"Состояние"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    printerStatus.queueDescription = obj;
                obj = [data objectForKey:@"Detail"];
                if (obj && [obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* detail = obj;
                    obj = [detail objectForKey:@"Status"];
                    if (obj && [obj isKindOfClass:[NSNumber class]])
                        printerStatus.fiscalStatus  = [obj boolValue];
                    
                    NSMutableString *fiscalStatus = [NSMutableString new];
                    
                    /*obj = [detail objectForKey:@"Mode"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        [fiscalStatus appendString:obj];
                    obj = [detail objectForKey:@"SubMode"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                    {
                        if (fiscalStatus.length > 0)
                            [fiscalStatus appendString:@"\n"];
                        [fiscalStatus appendString:obj];
                    }*/
                    
                    obj = [detail objectForKey:@"Error"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        [fiscalStatus appendString:obj];
                    
                    if (fiscalStatus.length > 0)
                        printerStatus.fiscalDescription = fiscalStatus;
                }
                
               obj = [data objectForKey:@"VOU"];
               if (obj && [obj isKindOfClass:[NSArray class]])
               {
                   NSArray *VOU = obj;
                   NSMutableArray *formObjects = [NSMutableArray new];
                   for (NSDictionary *currentForm in VOU) {
                       PrintingForm* form = [PrintingForm new];
                       
                       obj = [currentForm objectForKey:@"Type"];
                       if (obj && [obj isKindOfClass:[NSDictionary class]])
                       {
                           NSDictionary* type = obj;
                           obj = [type objectForKey:@"Name"];
                           if (obj && [obj isKindOfClass:[NSString class]])
                               form.name = obj;
                           obj = [type objectForKey:@"Code"];
                           if (obj && [obj isKindOfClass:[NSNumber class]])
                               form.type = [obj integerValue];
                       }
                       
                       obj = [currentForm objectForKey:@"Execute"];
                       if (obj && [obj isKindOfClass:[NSNumber class]])
                           form.isPrinting = [obj boolValue];
                       obj = [currentForm objectForKey:@"Error"];
                       if (obj && [obj isKindOfClass:[NSString class]])
                       {
                           NSError *error = [NSError errorWithDomain:@"qwe" code:0 userInfo:@{NSLocalizedDescriptionKey:obj}];
                           form.error = error;
                       }
                       
                       [formObjects addObject:form];
                       
                   }
                   
                   printerStatus.printingForms = formObjects;
               }
            }
        }
        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate printStatusComplete:_resultCode detailedDescription:printerStatus];
}


@end
