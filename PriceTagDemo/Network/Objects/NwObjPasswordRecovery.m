//
//  NwObjPasswordRecovery.m
//  Checklines
//
//  Created by Kurochkin on 07/11/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObjPasswordRecovery.h"
#import "Logger.h"
#import "MCPServer.h"
#import "SBJson.h"
#import "NSString+MD5.h"

@implementation NwObjPasswordRecovery

- (id)init
{
    self = [super init];
    if (self)
    {
        _phoneNumber = nil;
        _password = nil;
        _resultCode = -1;
        _accessToken = nil;
        _delegate = nil;
    }
    return self;
}

- (void)dealloc
{
    [_password release];
    [_phoneNumber release];
    [_activationCode release];
    [_accessToken release];
    [_userId release];
    [_delegate release];
    [_email release];
    _delegate = nil;
    
    [super dealloc];
}

- (void) setDelegate:(id<PasswordRecoveryDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(PasswordRecoveryDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        if (_delegate)
        [_delegate release];
        
        _delegate = [delegate retain];
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (NSURLRequest*) buildStartRecoveryRequest:(NSString*) url
{
    // Check input parameters:
    if ( _phoneNumber == Nil )
    {
        [Logger log:self method:@"run" format:@"'Phone' property is not set"];
        return nil;
    }
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/agent/recover_start/", url];
    nwReq.httpMethod = HTTP_METHOD_POST;
    [nwReq addParam:@"phone" withValue:_phoneNumber];
    [nwReq addParam:@"email" withValue:_email];
    [nwReq addParam:@"password" withValue:[_password sha256]];
    
    return [nwReq buildURLRequest];
}

- (NSURLRequest*) buildConfirmationRecoveryRequest:(NSString*)url
{
    // Check input parameters:
    if ( _activationCode == Nil )
    {
        [Logger log:self method:@"run" format:@"'Activation code' property is not set"];
        return nil;
    }
    
    if ( [[MCPServer instance] accessToken].length == 0 )
    {
        [Logger log:self method:@"run" format:@"'Session id' cookie is not defined"];
        return nil;
    }
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/agent/recover_finish/", url];
    nwReq.httpMethod = HTTP_METHOD_POST;
    [nwReq addParam:@"active_code" withValue:_activationCode];
    [nwReq addParam:@"token" withValue:[MCPServer instance].accessToken];
    return [nwReq buildURLRequest];
}

- (void) run: (NSString*) url
{
    _http_method = HTTP_METHOD_GET;
    NSURLRequest *__exec_request = nil;
    
    if (_stage == StartRecoveryStage)
    {
        __exec_request = [self buildStartRecoveryRequest:url];
        [[MCPServer instance] setRegisterSessionId:nil];
    }
    else
        __exec_request = [self buildConfirmationRecoveryRequest:url];
    
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

- (void) complete: (BOOL) isSuccessfull
{
    [super complete:isSuccessfull];     // disable network activity indicator
    
    _succeeded = isSuccessfull;
    
    _resultCode = -1;
    if ( _succeeded )
    {   // Request successfully performed
        NSString *dataString = [[NSString alloc] initWithData:_exec_data encoding:NSUTF8StringEncoding];
        [Logger log:self method:Nil format:@"TextRepres.: %@", dataString];

        
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
        
        if ( _resultCode == 0 && _stage == ConfirmationRecoveryStage)
        {
            
            obj = [result objectForKey:@"userId"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            {
                self.userId = [NSString stringWithString:obj];
                [Logger log:self method:@"complete" format:@"user ID = %@", obj];
            }
        }
        else if (_stage == StartRecoveryStage && _resultCode == 0)
        {
            
            obj = [result objectForKey:@"token"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            {
                [MCPServer instance].accessToken = [NSString stringWithString:obj];
                [Logger log:self method:@"complete" format:@"session ID = %@", obj];
            }
            else
            {
                _resultCode = -1;
                [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
            }
        }
        
        [dataString release];
    }
    
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
    {
        if (_stage == StartRecoveryStage)
            [_delegate passwordRecoveryComplete:_resultCode];
        else
            [_delegate passwordRecoveryConfirmed:_resultCode];
    }
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


@end
