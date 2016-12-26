//
//  NwobjSendAcceptanes.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 22/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjSendAcceptanes.h"
#import "Logger.h"

@implementation NwobjSendAcceptanes

- (id)init
{
    self = [super init];
    if (self)
    {
        _resultCode = -1;
        _delegate = nil;
    }
    return self;
}

- (void)dealloc
{
}

- (void) setDelegate:(id<AcceptanesDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(AcceptanesDelegate)] )
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
    if ( _acceptanesData == Nil )
    {
        [Logger log:self method:@"run" format:@"'acceptanesData' property is not set"];
        [self complete:NO];
        return;
    }
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[NwRequest alloc] init];
    
    //NSDictionary *wrapper = @{@"value":_cartData};
    NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:_acceptanesData options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:dataToSend encoding:NSUTF8StringEncoding];
    
    [Logger log:self method:@"sendAcceptanes:" format:@"JSON Dump: %@", string];
    /*string = @"<root type=\"object\">"
     "<obj type=\"object\">"
     "<SiteID type=\"number\">392</SiteID>"
     "<EmailID type=\"string\">test@gmail.com</EmailID>"
     "<Password type=\"string\">test123</Password>"
     "</obj>"
     "</root>";*/
    //string = @"{\"value\":1}";
    
    //#if RIVGOSH
    //
    //    nwReq.URL = [NSMutableString stringWithFormat:@"%@/client/?barcode=%@", url, _cardNumber ];
    //#else
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/PostAcceptanesItems?ShopName=%@", url, _shopId];
    //#endif
    nwReq.httpMethod = HTTP_METHOD_POST;
    [nwReq setRawBody:string];
    //[nwReq addParam:@"value" withValue:string];
    //[nwReq addParam:@"deviceId" withValue:uuid];
    //[nwReq setRawBody:string];
    
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
    
    _resultCode = -1;
    //ItemInformation *itemInfo = nil;
    
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
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:_exec_data options:0 error:nil];
        
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
        
        //id obj = nil;
        
        if ( _resultCode == 0 )
        {
            
        }
        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate && [_delegate respondsToSelector:@selector(sendAcceptanesComplete:)] )
        [_delegate sendAcceptanesComplete:_resultCode];
}

@end
