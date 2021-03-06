//
//  NwobjInventoryItemDescription.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 04.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjInventoryItemDescription.h"
#import "Logger.h"
#import "WarehouseInformation.h"

@interface NwobjInventoryItemDescription ()
@property (nonatomic, copy) NSString* path;
@end

@implementation NwobjInventoryItemDescription

- (id)init
{
    self = [super init];
    if (self)
    {
        _resultCode = -1;
        self.accessToken = @"";
        self.userId = @"";
        _delegate = nil;
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.path = [[NSString alloc] initWithFormat:@"%@/inventoryItems.arch", docDir];
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
#if RIVGOSH
    
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/addmat/4584GGR/?code=%@", url, _barcode];
    nwReq.httpMethod = HTTP_METHOD_POST;
#else
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/GetItems", url];
    nwReq.httpMethod = HTTP_METHOD_GET;
    if (_barcode)
        [nwReq addParam:@"barcode" withValue:_barcode];
#endif
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
#ifdef RIVGOSH
            [self rivGoshParser:result];
            return;
#endif
            obj = [result objectForKey:@"All_ItemsInvent"];
            if (obj && [obj isKindOfClass:[NSArray class]])
            {
                [self saveAllItems:obj];
                return;
            }
            
            itemInfo = [self parseItemInfo:result];
            if (!itemInfo.itemId)
                itemInfo.barcode = _barcode;
            
            //obj = [result objectForKey:@"token"];
            //if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
            // {
            //     self.accessToken = obj;
            //     [Logger log:self method:@"complete" format:@"session ID = %@", obj];
            // }
            /*
             else
             {
             _resultCode = -1;
             [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
             }
             */
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
    NSMutableDictionary *finalItems = [NSMutableDictionary new];
    
    for (NSDictionary* result in allItems) {
        ItemInformation* itemInfo = [self parseItemInfo:result];
        NSString* key = itemInfo.barcode ? itemInfo.barcode:@"unknown";
        [finalItems setObject:itemInfo forKey:key];
    }
    
    
    [NSKeyedArchiver archiveRootObject:finalItems toFile:_path];
    
    if ( _delegate )
        [_delegate itemDescriptionComplete:_resultCode itemDescription:nil];
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
    
    obj = [result objectForKey:@"details"];
    if (obj && [obj isKindOfClass:[NSArray class]])
    {
        NSMutableArray *finalArray = [NSMutableArray new];
        NSArray *warehouses = obj;
        for (int i = 0; i < warehouses.count; ++i) {
            WarehouseInformation *warehouse = [WarehouseInformation new];
            NSDictionary *warehouseServer = warehouses[i];
            
            obj = [warehouseServer objectForKey:@"Id"];
            if (obj != Nil  && [obj isKindOfClass:[NSNumber class]] )
                warehouse.wid = [obj integerValue];
            obj = [warehouseServer objectForKey:@"count"];
            if (obj != Nil  && [obj isKindOfClass:[NSNumber class]] )
                warehouse.count = [obj integerValue];
            obj = [warehouseServer objectForKey:@"rez_count"];
            if (obj != Nil  && [obj isKindOfClass:[NSNumber class]] )
                warehouse.reservedCount = [obj integerValue];
            obj = [warehouseServer objectForKey:@"name"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
                warehouse.name = obj;
            
            [finalArray addObject:warehouse];
            
        }
        
        itemInfo.warehouses = finalArray;
    }
    
    obj = [result objectForKey:@"parameters"];
    if (obj && [obj isKindOfClass:[NSArray class]])
    {
        NSMutableArray *finalArray = [NSMutableArray new];
        NSArray *parameters = obj;
        for (int i = 0; i < parameters.count; ++i) {
            ParameterInformation *parameter = [ParameterInformation new];
            NSDictionary *parameterServer = parameters[i];
            
            obj = [parameterServer objectForKey:@"paramName"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
                parameter.name = obj;
            obj = [parameterServer objectForKey:@"paramValue"];
            if (obj != Nil  && [obj isKindOfClass:[NSString class]] )
                parameter.value = obj;
            
            [finalArray addObject:parameter];
            
        }
        
        itemInfo.additionalParameters = finalArray;
    }
    
    return itemInfo;
}



- (void) rivGoshParser:(NSDictionary*) result
{
    ItemInformation *itemInfo = nil;
    id obj = [result objectForKey:@"data"];
    if (obj && [obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *data = obj;
        obj = [data objectForKey:@"DTL"];
        if (obj && [obj isKindOfClass:[NSArray class]])
        {
            NSArray *dtl = obj;
            if (dtl.count > 0)
            {
                itemInfo = [ItemInformation new];
                obj =  dtl.firstObject;
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* dictParams = obj;
                    obj = [dictParams objectForKey:@"Сумма"];
                    if (obj && [obj isKindOfClass:[NSNumber class]])
                        itemInfo.price = [obj doubleValue];
                    obj = [dictParams objectForKey:@"ПолноеНаименование"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        itemInfo.name = obj;
                    obj = [dictParams objectForKey:@"Номенклатура_Код"];
                    if (obj && [obj isKindOfClass:[NSNumber class]])
                        itemInfo.itemId = [obj integerValue];
                    obj = [dictParams objectForKey:@"СерийныйНомер"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        itemInfo.article = obj;
                    
                }
                
            }
        }
    }
    
    if ( _delegate )
        [_delegate itemDescriptionComplete:_resultCode itemDescription:itemInfo];
}


@end
