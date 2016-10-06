//
//  NwobjPaymentsHistory.m
//  Checklines
//
//  Created by Denis Kurochkin on 12/17/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import "NwobjPaymentsHistory.h"
#import "SBJson.h"
#import "Logger.h"

@implementation NwobjPaymentsHistory

- (void) dealloc
{
    [_userId release];
    [_userSession release];
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
    }
    return self;
}

- (void) setDelegate:(id<PaymentsHistoryDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(PaymentsHistoryDelegate)] )
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
    if ( _userId == Nil )
    {
        [Logger log:self method:@"run" format:@"'userId' property is not set"];
        [self complete:NO];
        return;
    }
    if ( _userSession == Nil )
    {
        [Logger log:self method:@"run" format:@"'userSession' property is not set"];
        [self complete:NO];
        return;
    }
    
    
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/pay/status/", url];
    nwReq.httpMethod = HTTP_METHOD_GET;
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
    NSMutableArray* paysArray = [[NSMutableArray new] autorelease];
    
    _resultCode = -1;
    if ( _succeeded )
    {   // Request successfully performed
        NSString *dataString = [[NSString alloc] initWithData:_exec_data encoding:NSUTF8StringEncoding];
        [Logger log:self method:Nil format:@"TextRepres.: %@", dataString];
        
        
        
        // Parse JSON
        NSDictionary *result = [dataString JSONValue];
        if ( result )
        {
            if ( [result objectForKey:@"error_code"])
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
        
        if ( _resultCode == 0 )
        {
            
            NSArray *serverHistory = nil;
            id obj = [result objectForKey:@"pays"];
            if (obj && [obj isKindOfClass:[NSArray class]])
                serverHistory = obj;
            
            NSEnumerator *paysEnumerator = [serverHistory objectEnumerator];
            NSDictionary *currentPayment = nil;
            while (currentPayment = [paysEnumerator nextObject]) {
                PaymentInformation *info = [[PaymentInformation new] autorelease];
                
                obj = [currentPayment objectForKey:@"status"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    info.status = [obj intValue];
                obj = [currentPayment objectForKey:@"amount"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    info.quantity = [obj intValue];
                obj = [currentPayment objectForKey:@"price"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    info.amount = [obj doubleValue];
                obj = [currentPayment objectForKey:@"request_dt"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    info.date = [NSDate dateWithTimeIntervalSince1970:[obj doubleValue]];
                
                [paysArray addObject:info];
                
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
        [_delegate paymentsHistoryComplete:_resultCode payments:paysArray];
}

@end
