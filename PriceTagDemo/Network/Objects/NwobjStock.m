//
//  NwobjStock.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 30/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjStock.h"
#import "Logger.h"

@implementation NwobjStock

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

- (void) setDelegate:(id<StockDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(StockDelegate)] )
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
    if (_barcode)
    {
        nwReq.URL = [NSMutableString stringWithFormat:@"%@/Stock", url];
        [nwReq addParam:@"barcode" withValue:_barcode];
    }
    else
    {
        nwReq.URL = [NSMutableString stringWithFormat:@"%@/Stocks", url];
        [nwReq addParam:@"shopcode" withValue:_shopId];
    }
    
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
    ItemInformation *itemInfo = nil;
    NSArray<ItemInformation*>* items = nil;
    
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
            
            obj = [result objectForKey:@"All_Items"];
            if (obj && [obj isKindOfClass:[NSArray class]])
            {
                [self saveAllItems:obj];
                return;
            }
            
            itemInfo = [self parseItemInfo:result];
        }
        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate stockComplete:_resultCode items:items];
}

- (void) saveAllItems:(NSArray*)allItems
{
    //NSMutableDictionary *finalItems = [NSMutableDictionary new];
    NSMutableArray* parsedItems = [NSMutableArray new];
    
    for (NSDictionary* result in allItems) {
        ItemInformation* itemInfo = [self parseItemInfo:result];
        [parsedItems addObject:itemInfo];
        //NSString* key = itemInfo.barcode ? itemInfo.barcode:@"unknown";
        //[finalItems setObject:itemInfo forKey:key];
    }
    
    _completionHandler(parsedItems);
    //[NSKeyedArchiver archiveRootObject:finalItems toFile:_path];
    
    if ( _delegate )
        [_delegate allStocksComplete:_resultCode items:nil];
}

- (ItemInformation*) parseItemInfo:(NSDictionary*) result
{
    ItemInformation *itemInfo = [ItemInformation new];
    
    id obj = [result objectForKey:@"Id"];
    if (obj != Nil  && [obj isKindOfClass:[NSNumber class]] )
    {
        itemInfo.itemId = [obj integerValue];
        //[Logger log:self method:@"complete" format:@"user ID = %@", obj];
    }
    obj = [result objectForKey:@"barCode"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.barcode = obj;
    obj = [result objectForKey:@"cost"];
    if (obj != Nil  && [obj isKindOfClass:[NSNumber class]] )
        itemInfo.price = [obj doubleValue];
    obj = [result objectForKey:@"itemDescription"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.article = obj;
    obj = [result objectForKey:@"itemName"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.name = obj;
    obj = [result objectForKey:@"photo"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        itemInfo.imageName = [NSString stringWithFormat:@"%d", [obj intValue]];
    obj = [result objectForKey:@"material"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.material = obj;
    obj = [result objectForKey:@"color"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.color = obj;
    obj = [result objectForKey:@"diameter"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        itemInfo.diameter = obj;
    obj = [result objectForKey:@"length"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        itemInfo.length = obj;
    obj = [result objectForKey:@"width"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        itemInfo.width = obj;
    obj = [result objectForKey:@"higth"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
        itemInfo.height = obj;
    obj = [result objectForKey:@"paramValue1"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.unit = obj;
    obj = [result objectForKey:@"remains"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.stock = [obj integerValue];;
    
    return itemInfo;
}

@end
