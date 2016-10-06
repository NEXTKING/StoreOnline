//
//  NwobjItemDescription.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 26/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjItemDescription.h"
#import "Logger.h"
#import "WarehouseInformation.h"

@implementation NwobjItemDescription

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

- (void) setDelegate:(id<ItemDescriptionDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(ItemDescriptionDelegate)] )
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
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/thin/goodInfo", url];
    nwReq.httpMethod = HTTP_METHOD_PUT;
    
    NSString* inputJSON = [NSString stringWithFormat:@"{\"ean\":\"%@\"}", _barcode];
    [nwReq setRawBody:inputJSON];
    
    
    
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
    
    if ( _succeeded )
    {   // Request successfully performed
        //NSString *dataString = [[NSString alloc] initWithData:_exec_data encoding:NSUTF8StringEncoding];
        //[Logger log:self method:Nil format:@"TextRepres.: %@", dataString];
        
        //Parse JSON
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:_exec_data options:0 error:nil];
        
        if ( result )
        {
            /*if ( [result objectForKey:@"result"] != Nil )
            {
                _resultCode = [[result valueForKey:@"result"] intValue];
                [Logger log:self method:@"complete" format:@"result=%d", _resultCode];
            }
            else
            {
                _resultCode = -1;
                [Logger log:self method:@"complete" format:@"'result' is not found"];
            }*/
            
            [Logger log:self method:@"complete" format:@"Json parsed", _resultCode];
        }
        else
            _resultCode = -2;
        
        //id obj = nil;
         
        if ( _resultCode == 0 )
        {
            
            
            itemInfo = [self parseItemInfo:result];
        }
        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate itemDescriptionComplete:_resultCode itemDescription:itemInfo];
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
        [_delegate itemDescriptionComplete:_resultCode itemDescription:nil];
}

- (ItemInformation*) parseItemInfo:(NSDictionary*) result
{
    ItemInformation *itemInfo = [ItemInformation new];
    NSMutableArray *additionalParams = [[NSMutableArray alloc] init];
    itemInfo.barcode = _barcode;
    
    id obj = [result objectForKey:@"Id"];
    if (obj != Nil  && [obj isKindOfClass:[NSNumber class]] )
    {
        itemInfo.itemId = [obj integerValue];
        //[Logger log:self method:@"complete" format:@"user ID = %@", obj];
    }
    obj = [result objectForKey:@"Price"];
    if (obj != Nil  && [obj isKindOfClass:[NSNumber class]] )
        itemInfo.price = [obj doubleValue];
    obj = [result objectForKey:@"Article"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.article = obj;
    obj = [result objectForKey:@"NameGoods"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.name = obj;
    obj = [result objectForKey:@"Unit"];
    if (obj && [obj isKindOfClass:[NSString class]])
        itemInfo.unit = obj;
    
    
    obj = [result objectForKey:@"Stock"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
    {
        ParameterInformation *param = [ParameterInformation new];
        param.name = @"Запас";
        param.value = [NSString stringWithFormat:@"%d", [obj intValue]];
        [additionalParams addObject:param];
    }
    obj = [result objectForKey:@"POSPrice"];
    if (obj && [obj isKindOfClass:[NSNumber class]])
    {
        ParameterInformation *param = [ParameterInformation new];
        param.name = @"Цена на кассе";
        param.value = [NSString stringWithFormat:@"%.2f", [obj doubleValue]];
        [additionalParams addObject:param];
    }
    
    
    itemInfo.additionalParameters = additionalParams;
    
    return itemInfo;
}

@end
