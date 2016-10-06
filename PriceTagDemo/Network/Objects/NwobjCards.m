//
//  NwobjCards.m
//  MobileBanking
//
//  Created by Sergey Sasin on 29.04.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import "NwobjCards.h"
#import "SBJson.h"

#import "Logger.h"

@implementation NwobjCards

@synthesize accessToken = _accessToken;
@synthesize succeeded = _succeeded;
@synthesize resultCode = _resultCode;
@synthesize delegate = _delegate;
@synthesize cardsList = _cardsList;

- (id)init 
{
    self = [super init];
    if (self) 
    {
        _accessToken = nil;
        _succeeded = NO;
        _resultCode = -1;
        _delegate = nil;
        _cardsList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_cardsList release];
    [_accessToken release];
    [_delegate release];
    _accessToken = nil;
    _delegate = nil;
    
    [super dealloc];
}

- (void) setDelegate:(id<CardsDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    [_delegate release];
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(CardsDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        _delegate = delegate;
        [_delegate retain];
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (void) run: (NSString*) url
{
    // Check input parameters:
    if ( _accessToken == Nil )
    {
        [Logger log:self method:@"run" format:@"'accessToken' property is not set"];
        [self complete:NO];
        return;
    }
    
    // Parameters are checked, perform the request:
#ifdef ENABLE_ACCESS_TOKEN_PARAMETER
    NSString *strurl = [NSString stringWithFormat:@"%@/cards?accessToken=%@",
                        url, _accessToken];
#else
    NSString *strurl = [NSString stringWithFormat:@"%@/cards",
                        url];
#endif
    
    _exec_url = [NSURL URLWithString:strurl];
    
    [Logger log:self method:@"run" format: @"\n\t %@", strurl];
    
    if ( _exec_url == nil )
        return;
    
    _exec_request = [NSMutableURLRequest requestWithURL:_exec_url];
    [_exec_request setHTTPMethod:@"GET"];
    [_exec_request setHTTPShouldHandleCookies:NO];
    [_exec_request addValue:[NSString stringWithFormat:@"JSESSIONID=%@", _accessToken] forHTTPHeaderField:@"Cookie"];
    
    assert(_exec_request != nil);
    
    _exec_connection = [[NSURLConnection alloc] initWithRequest:_exec_request delegate:self];
    
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
        
        // Process results
        // Parse JSON
        NSDictionary *result = [dataString JSONValue];
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
        
        if ( _resultCode == 0 )
        {
            if ( [result objectForKey:@"cards"] != Nil )
            {
                NSArray *cards = [result objectForKey:@"cards"];
                //NSMutableArray *cardNumbers = [[NSMutableArray alloc] init];
                NSEnumerator *enumerator = [cards objectEnumerator];
                NSDictionary *currCardInfo = Nil;
                while ( (currCardInfo = (NSDictionary*)[enumerator nextObject]) ) 
                {
                    CardInformation *cardInfo = [CardInformation new];
                    cardInfo.number = @"";
                    cardInfo.brand = @"-";
                    cardInfo.balance = 0.0;
                    cardInfo.currency = @"";
                    
                    id obj = Nil;
                    obj = [currCardInfo objectForKey:@"number"];
                    if ( obj && [obj isKindOfClass:[NSString class]] )
                    //{
                        cardInfo.number = obj;
                        //[cardNumbers addObject:obj];
                    //}
                    obj = [currCardInfo objectForKey:@"name"];
                    if ( obj && [obj isKindOfClass:[NSString class]] )
                        cardInfo.name = obj;
                    obj = [currCardInfo objectForKey:@"scid"];
                    if ( obj && [obj isKindOfClass:[NSString class]] )
                        cardInfo.scid = obj;
                    obj = [currCardInfo objectForKey:@"brand"];
                    if ( obj && [obj isKindOfClass:[NSString class]] )
                        cardInfo.brand = obj;
                    obj = [currCardInfo objectForKey:@"balance"];
                    if ( obj && [obj isKindOfClass:[NSNumber class]] )
                        cardInfo.balance = [obj doubleValue];
                    obj = [currCardInfo objectForKey:@"currency"];
                    if ( obj && [obj isKindOfClass:[NSString class]] )
                        cardInfo.currency = obj;
                    
                    [Logger log:self method:@"complete" format:@"scid=%@\n\tnumber=%@\n\tbrand=%@\n\tbalance=%f\n\tcurrency=%@",
                     cardInfo.scid, cardInfo.number, cardInfo.brand, cardInfo.balance, cardInfo.currency];
                    
                    [_cardsList addObject:cardInfo];
                    [cardInfo release];
                }
                
                //[[NSUserDefaults standardUserDefaults] setObject:cardNumbers forKey:@"cardNumbers"];
                //[cardNumbers release];
            }
            else
            {
                _resultCode = -1;
                [Logger log:self method:@"complete" format:@"'cards' is not found"];
            }
        }
        [dataString release];        
    }
    
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate cardsComplete:_resultCode cards:_cardsList];
}

@end
