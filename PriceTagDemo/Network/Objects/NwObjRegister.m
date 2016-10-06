//
//  NwObjRegister.m
//  Checklines
//
//  Created by Denis Kurochkin on 12.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObjRegister.h"
#import "Logger.h"
#import "SBJson.h"
#import "NSString+MD5.h"
#import "MCPServer.h"

@implementation NwObjRegister

- (id)init
{
    self = [super init];
    if (self)
    {
        _regesterParams = nil;
        _resultCode = -1;
        _accessToken = nil;
        _delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    [_regesterParams release];
    [_activationCode release];
    [_accessToken release];
    [_userId release];
    [_delegate release];
    _delegate = nil;
    
    [super dealloc];
}

- (void) setDelegate:(id<RegisterDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(RegisterDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        if (_delegate)
            [_delegate release];
        
        _delegate = [delegate retain];
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (NSURLRequest*) buildStartRegisterRequest:(NSString*) url
{
    // Check input parameters:
    if ( _regesterParams.phone == Nil )
    {
        [Logger log:self method:@"run" format:@"'Phone' property is not set"];
        return nil;
    }
    if ( _regesterParams.password == Nil )
    {
        [Logger log:self method:@"run" format:@"'Password' property is not set"];
        return nil;
    }
    if ( _regesterParams.firstName == Nil )
    {
        [Logger log:self method:@"run" format:@"'First name' property is not set"];
        return nil;
    }
    if ( _regesterParams.lastName == Nil )
    {
        [Logger log:self method:@"run" format:@"'Last name' property is not set"];
        return nil;
    }
    if ( _regesterParams.lastName == Nil )
    {
        [Logger log:self method:@"run" format:@"'E-mail' property is not set"];
        return nil;
    }
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/agent/register_start/", url];
    nwReq.httpMethod = HTTP_METHOD_POST;
    [nwReq addParam:@"phone" withValue:_regesterParams.phone];
    [nwReq addParam:@"password" withValue:[_regesterParams.password sha256]];
    [nwReq addParam:@"first_name" withValue:_regesterParams.firstName];
    [nwReq addParam:@"last_name" withValue:_regesterParams.lastName];
    [nwReq addParam:@"email" withValue:_regesterParams.email];
    [nwReq addParam:@"platform" withValue:@"2"];
    
    return [nwReq buildURLRequest];
}

- (NSURLRequest*) buildConfirmationRegisterRequest:(NSString*)url
{
    // Check input parameters:
    if ( _activationCode == Nil )
    {
        [Logger log:self method:@"run" format:@"'Phone' property is not set"];
        return nil;
    }
    
    if ( [[MCPServer instance] registerSessionId].length == 0 )
    {
        [Logger log:self method:@"run" format:@"'Session id' cookie is not defined"];
        return nil;
    }
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@//mobile/agent/register_finish/", url];
    nwReq.httpMethod = HTTP_METHOD_POST;
    [nwReq addParam:@"active_code" withValue:_activationCode];
    [nwReq addParam:@"token" withValue:[[MCPServer instance] registerSessionId]];
#if TARGET_IPHONE_SIMULATOR
    [nwReq addParam:@"device_id" withValue:@"123456789Simulator"];
    //running on device
#else
    [nwReq addParam:@"device_id" withValue:[UIDevice currentDevice].identifierForVendor.UUIDString];
#endif
    return [nwReq buildURLRequest];
}

- (void) run: (NSString*) url
{
    _http_method = HTTP_METHOD_GET;
    NSURLRequest *__exec_request = nil;
    
    if (_stage == StartRegisterStage)
    {
        __exec_request = [self buildStartRegisterRequest:url];
        [[MCPServer instance] setRegisterSessionId:nil];
    }
    else
        __exec_request = [self buildConfirmationRegisterRequest:url];
    
    if (!__exec_request)
    {
        [self complete:NO];
        return;
    }
    
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

- (BOOL) setRegisterSession:(NSString*) sessionHeader
{
    if (!sessionHeader)
        return NO;
    
    NSRange range = [sessionHeader rangeOfString:@"sessionid="];
    if (range.location == NSNotFound)
        return NO;
    
    NSString*  prefixCut = [[sessionHeader substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange semicolonRange = [prefixCut rangeOfString:@";"];
    if (semicolonRange.location == NSNotFound)
        return NO;
    NSString* sessionValue = [prefixCut substringToIndex:semicolonRange.location];
    [[MCPServer instance] setRegisterSessionId:sessionValue];
    
    return YES;
    
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
        
        /*BOOL isRegisterSessionSet = NO;
        if (_stage == StartRegisterStage)
        {
            NSString* sessionHeader = [_unsortedCookies objectForKey:@"Set-Cookie"];
            isRegisterSessionSet = [self setRegisterSession:sessionHeader];
        }*/
        
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
            
            /*if (_stage == StartRegisterStage && _resultCode == 0 && !isRegisterSessionSet)
                _resultCode = 2;*/
        }
        else
            _resultCode = -2;
        
        id obj = nil;
        
        if ( _resultCode == 0 && _stage == ConfirmationRegisterStage)
        {
            
            obj = [result objectForKey:@"userId"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            {
                self.userId = [NSString stringWithString:obj];
                [Logger log:self method:@"complete" format:@"user ID = %@", obj];
            }
            
            obj = [result objectForKey:@"sessionId"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            {
                self.accessToken = [NSString stringWithString:obj];
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
        else if (_stage == StartRegisterStage && _resultCode == 0)
        {
            /*if ( _cookies )
            {
                NSArray* keys = [_cookies allKeys];
                for (NSString *key in keys)
                    NSLog(@"Cookie key: %@", key);
                
            }*/
            
            obj = [result objectForKey:@"token"];
            if (obj && [obj isKindOfClass:[NSString class]])
                [[MCPServer instance] setRegisterSessionId:obj];
        }
        
        [dataString release];
    }
    
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
    {
        if (_stage == StartRegisterStage)
            [_delegate registerComplete:_resultCode];
        else
            [_delegate registerConfirmed:_resultCode userId:_userId sessionId:_accessToken];
    }
}

@end
