//
//  NwobjZones.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjZones.h"
#import "Logger.h"

@implementation NwobjZones

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

- (void) setDelegate:(id<ZonesDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(ZonesDelegate)] )
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
    if ( _shopID == Nil )
    {
        [Logger log:self method:@"run" format:@"'shopID' property is not set"];
        [self complete:NO];
        return;
    }
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[NwRequest alloc] init];
#if RIVGOSH
   /* NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* receiptID = [userDefaults valueForKey:@"currentReceiptID"];
    NSMutableString* urlString = [NSMutableString stringWithFormat:@"%@/client/?barcode=%@", url, _cardNumber ];
    if (receiptID)
        [urlString appendFormat:@"&id=%@", receiptID];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/addclient/4584GGR/?barcode=%@", url, _cardNumber ]; */
#else
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/GetZones", url];
#endif
    nwReq.httpMethod = HTTP_METHOD_GET;
    [nwReq addParam:@"shopcode" withValue:_shopID];
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
    NSMutableArray* zonesArray = [NSMutableArray new];
    
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
            obj = [result objectForKey:@"All_Zones"];
            if (obj && [obj isKindOfClass:[NSArray class]])
            {
                zonesArray = obj;
            }
            
        }
            /*
             else
             {
             _resultCode = -1;
             [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
             }
             */
        }
    
        
        //[dataString release];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*path = [[NSString alloc] initWithFormat:@"%@/zones.arch", docDir];
    [NSKeyedArchiver archiveRootObject:zonesArray toFile:path];
    
    
        if ( _delegate )
            [_delegate zonesComplete:_resultCode zones:zonesArray];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protoco

@end
