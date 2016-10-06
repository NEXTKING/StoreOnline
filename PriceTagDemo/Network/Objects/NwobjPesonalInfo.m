//
//  NwobjPesonalInfo.m
//  Checklines
//
//  Created by Kurochkin on 29/10/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwobjPesonalInfo.h"
#import "Logger.h"
#import "SBJson.h"

@implementation NwobjPesonalInfo

- (void) dealloc
{
    [_userId release];
    [_userSession release];
    [_name release];
    [_delegate release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _succeeded = NO;
        _resultCode = -1;
        _delegate = nil;
        _experience = -1;
        _price = -1;
        _reliability = -1;
        _pays = -1;
    }
    return self;
}

- (void) setDelegate:(id<PersonalInfoDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(PersonalInfoDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        if (_delegate)
            [_delegate release];
        
        _delegate = [delegate retain];
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (void) run: (NSString*) url
{
    // Check input parameters:
    /*if ( _userId == Nil )
    {
        [Logger log:self method:@"run" format:@"'userId' property is not set"];
        [self complete:NO];
        return;
    }*/
    if ( _userSession == Nil )
    {
        [Logger log:self method:@"run" format:@"'userSession' property is not set"];
        [self complete:NO];
        return;
    }
    
    
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/agent/profile/", url];
    nwReq.httpMethod = _http_method;
    //[nwReq addParam:@"userId" withValue:_userId];
    [nwReq addParam:@"token" withValue:_userSession];
    
    NSURLRequest *__exec_request = [nwReq buildURLRequest];
    
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
    AgentInformation* agentInfo = nil;
    
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
        
        if ( _resultCode == 0 )
        {
            agentInfo = [[AgentInformation new] autorelease];
            NSDictionary *agentInfoDict = nil;
            obj = [result objectForKey:@"agent"];
            if (obj && [obj isKindOfClass:[NSDictionary class]])
            {
                agentInfoDict = obj;
                
                obj = [agentInfoDict objectForKey:@"first_name"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    agentInfo.firstName = obj;
                obj = [agentInfoDict objectForKey:@"last_name"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    agentInfo.lastName = obj;
                obj = [agentInfoDict objectForKey:@"email"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    agentInfo.email = obj;
                obj = [agentInfoDict objectForKey:@"phone"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    agentInfo.phone = obj;
                obj = [agentInfoDict objectForKey:@"experience"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    agentInfo.experience = [obj integerValue];
                obj = [agentInfoDict objectForKey:@"points"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    agentInfo.points = [obj doubleValue];
                obj = [agentInfoDict objectForKey:@"earn_amount"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    agentInfo.earnAmount = [obj integerValue];
                obj = [agentInfoDict objectForKey:@"pays"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    _pays = [obj integerValue];
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
        [_delegate personalInfoCompleted:_resultCode agentInformation:agentInfo];
}

@end
