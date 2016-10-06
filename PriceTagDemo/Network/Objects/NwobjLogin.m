//
//  NwobjLogin.m
//  Checklines
//
//  Created by Denis Kurochkin on 18.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwobjLogin.h"
#import "Logger.h"
#import "SBJson.h"
#import "NSString+MD5.h"

@interface NwobjLogin()
//@property (nonatomic, copy) NSString* accessToken;
//@property (nonatomic, copy) NSString* userId;
@end


@implementation NwobjLogin

- (id)init
{
    self = [super init];
    if (self)
    {
        _userPhone = Nil;
        _userPassword = Nil;
        _resultCode = -1;
        self.accessToken = @"";
        self.userId = @"";
        _delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    [_userPhone release];
    [_userPassword release];
    [_accessToken release];
    [_userId release];
    _delegate = nil;
    
    [super dealloc];
}

- (void) setDelegate:(id<LoginDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(LoginDelegate)] )
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
    if ( _userPhone == Nil )
    {
        [Logger log:self method:@"run" format:@"'userPhone' property is not set"];
        [self complete:NO];
        return;
    }
    if ( _userPassword == Nil )
    {
        [Logger log:self method:@"run" format:@"'userPassword' property is not set"];
        [self complete:NO];
        return;
    }
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/agent/auth/", url];
    nwReq.httpMethod = HTTP_METHOD_POST;
    [nwReq addParam:@"phone" withValue:_userPhone];
    [nwReq addParam:@"password" withValue:[_userPassword sha256]];
#if TARGET_IPHONE_SIMULATOR
    [nwReq addParam:@"device_id" withValue:@"123456789Simulator"];
    //running on device
#else
    [nwReq addParam:@"device_id" withValue:[UIDevice currentDevice].identifierForVendor.UUIDString];
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
        
        // Parse JSON
        NSDictionary *result = [dataString JSONValue];
        if ( result )
        {
            if ( [result objectForKey:@"error_code"] != Nil )
            {
                _resultCode = [[result valueForKey:@"error_code"] intValue];
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
            /*obj = [result objectForKey:@"token"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            {
                self.userId = obj;
                [Logger log:self method:@"complete" format:@"user ID = %@", obj];
            }
            */
            
            obj = [result objectForKey:@"token"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            {
                self.accessToken = obj;
                [Logger log:self method:@"complete" format:@"session ID = %@", obj];
            }
            /*
             else
             {
             _resultCode = -1;
             [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
             }
             */
        }
        
        [dataString release];
    }
    
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate loginComplete:_resultCode userId:self.userId sessionId:self.accessToken];
}


@end
