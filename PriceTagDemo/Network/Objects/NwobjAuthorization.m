//
//  NwobjAuthorization.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 25.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjAuthorization.h"
#import "UserSessionInformation.h"
#import "Logger.h"

@implementation NwobjAuthorization

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

- (void) setDelegate:(id<AuthorizationDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(AuthorizationDelegate)] )
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
    if ( _barcode == Nil )
    {
        [Logger log:self method:@"run" format:@"'barcode' property is not set"];
        [self complete:NO];
        return;
    }
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[NwRequest alloc] init];
#if RIVGOSH
    NSString* uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringToIndex:12];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/auth/%@/?code=%@", url,uuid, _barcode ];
#else
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/Price", url];
#endif
    nwReq.httpMethod = HTTP_METHOD_POST;
    //[nwReq addParam:@"barcode" withValue:_barcode];
    //[nwReq addParam:@"password" withValue:[_userPassword sha256]];
#if TARGET_IPHONE_SIMULATOR
    //[nwReq addParam:@"device_id" withValue:@"123456789Simulator"];
    //running on device
#else
    //[nwReq addParam:@"device_id" withValue:[UIDevice currentDevice].identifierForVendor.UUIDString];
#endif
    
    
    NSURLRequest *__exec_request = [nwReq buildURLRequest];
    
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
        
        id obj = nil;
        
        if ( _resultCode == 0 )
        {
            obj = [result objectForKey:@"data"];
            if (obj && [obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* data = obj;
                //UserSessionInformation* userSession = [UserSessionInformation new];
                
                obj = [data objectForKey:@"Пользователь"];
                if (obj && [obj isKindOfClass:[NSString class]])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"Username"];
                }
                
                obj = [data objectForKey:@"Касса"];
                if (obj && [obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* cashDict = obj;
                    obj = [cashDict objectForKey:@"Name"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"CashName"];
                }
                obj = [data objectForKey:@"ДенЯщик"];
                if (obj && [obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* cashDict = obj;
                    obj = [cashDict objectForKey:@"Name"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"CashboxName"];
                }
                obj = [data objectForKey:@"Магазин"];
                if (obj && [obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* cashDict = obj;
                    obj = [cashDict objectForKey:@"Name"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"StoreName"];
                }
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            
            
            //obj = [result objectForKey:@"token"];
            //if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            // {
            //     self.accessToken = obj;
            //     [Logger log:self method:@"complete" format:@"session ID = %@", obj];
            // }
            /*
             else
             {
             _resultCode = -1;
             [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
             }
             */
        }
        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate authorizationComplete:_resultCode rights:nil];
}

@end
