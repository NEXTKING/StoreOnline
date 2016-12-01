//
//  NwobjAcceptanes.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 17/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjAcceptanes.h"
#import "Logger.h"

@implementation NwobjAcceptanes

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
    /*if ( _barcode == Nil )
     {
     [Logger log:self method:@"run" format:@"'barcode' property is not set"];
     [self complete:NO];
     return;
     }*/
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[NwRequest alloc] init];
    
    nwReq.httpMethod = HTTP_METHOD_GET;
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/GetAcceptancesCV", url];
    [nwReq addParam:@"ShopName" withValue:_shopId];

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
    NSArray<AcceptanesInformation*>* items = nil;
    
    if ( _succeeded )
    {   // Request successfully performed
        //NSString *dataString = [[NSString alloc] initWithData:_exec_data encoding:NSUTF8StringEncoding];
        //[Logger log:self method:Nil format:@"TextRepres.: %@", dataString];
        
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
            
            obj = [result objectForKey:@"All_AcceptanceS"];
            if (obj && [obj isKindOfClass:[NSArray class]])
            {
                [self saveAllItems:obj];
                return;
            }
        }
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate acceptanesComplete:_resultCode items:items];
}

- (void) saveAllItems:(NSArray*)allItems
{
    NSMutableArray* parsedItems = [NSMutableArray new];
    
    for (NSDictionary* result in allItems) {
        AcceptanesInformation* acceptInfo = [self parseItemInfo:result];
        [parsedItems addObject:acceptInfo];
    }
    
    _completionHandler(parsedItems);
    
    if ( _delegate )
        [_delegate acceptanesComplete:_resultCode items:nil];
}

- (AcceptanesInformation*) parseItemInfo:(NSDictionary*) result
{
    AcceptanesInformation *acceptInfo = [AcceptanesInformation new];
    
    id obj = [result objectForKey:@"ItemBarCode"];
    if (obj != Nil  && [obj isKindOfClass:[NSString class]])
        acceptInfo.barcode = obj;
    
    obj = [result objectForKey:@"ContainerBarCode"];
    if (obj && [obj isKindOfClass:[NSString class]])
        acceptInfo.containerBarcode = obj;
    
    obj = [result objectForKey:@"TypeOfPacage"];
    if (obj != Nil  && [obj isKindOfClass:[NSString class]])
    {
        if ([obj isEqualToString:@"B"])
            acceptInfo.type = AcceptanesInformationItemTypeBox;
        else if ([obj isEqualToString:@"S"])
            acceptInfo.type = AcceptanesInformationItemTypeSet;
        else
            acceptInfo.type = AcceptanesInformationItemTypeItem;
    }
    else if (obj != Nil  && [obj isKindOfClass:[NSNull class]])
        acceptInfo.type = AcceptanesInformationItemTypeItem;
    
    obj = [result objectForKey:@"QuantityCount"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        acceptInfo.quantity = obj;
    
    obj = [result objectForKey:@"QuantityScanned"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        acceptInfo.scanned = obj;
    
    obj = [result objectForKey:@"DateOfOperation"];
    if (obj && [obj isKindOfClass:[NSString class]])
    {
        //NSISO8601DateFormatter *dateFormatter = [[NSISO8601DateFormatter alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        acceptInfo.date = [dateFormatter dateFromString:obj];
    }
    obj = [result objectForKey:@"IsScannedByHand"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        acceptInfo.manually = [NSNumber numberWithBool:obj];
    
    obj = [result objectForKey:@"IsComplete"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        acceptInfo.isComplete = [NSNumber numberWithBool:obj];
    
    obj = [result objectForKey:@"ID"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        acceptInfo.ID = obj;
    
    obj = [result objectForKey:@"ShopName"];
    if (obj && [obj isKindOfClass:[NSString class]])
        acceptInfo.shopName = obj;
    
    return acceptInfo;
}

@end
