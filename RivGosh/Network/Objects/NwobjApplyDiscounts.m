//
//  NwobjApplyDiscounts.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 23.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwobjApplyDiscounts.h"
#import "Logger.h"

@interface NSMutableString (XMLAdditions)
- (void) appendElement:(NSString*) element withText:(NSString*) text;
@end

@implementation NSMutableString (XMLAdditions)

- (void) appendElement:(NSString *)element withText:(NSString *)text
{
    [self appendFormat:@"<%@>%@</%@>",element,text,element];
}

@end

@implementation NwobjApplyDiscounts

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

- (void) setDelegate:(id<ApplyDiscountsDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(ApplyDiscountsDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        _delegate = delegate;
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (NSString*) serializeDiscounts
{
    NSMutableString* mutableString = [NSMutableString new];
    [mutableString appendString:@"<ArrayOfItemsLOYALTY xmlns=\"http://rivegauche.ru/ens\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"ArrayOfItemsLOYALTY\">"];
    
    for (DiscountInformation *discount in _discounts) {
        if (!discount.enabled)
            continue;
        
        NSMutableString* currentDiscountString = [NSMutableString new];
        
        [currentDiscountString appendElement:@"CARD" withText:discount.card];
        [currentDiscountString appendElement:@"LOYALTYPROGRAMM" withText:discount.name];
        [currentDiscountString appendElement:@"BONUSBALANCE" withText:[NSString stringWithFormat:@"%ld", (long)discount.bonusBalance]];
        [currentDiscountString appendElement:@"SUMBALANCE" withText:[NSString stringWithFormat:@"%.2f", discount.sumBalance]];
        [currentDiscountString appendElement:@"BONUSAVAIL" withText:[NSString stringWithFormat:@"%ld", (long)discount.count]];
        [currentDiscountString appendElement:@"SUMAVAIL" withText:[NSString stringWithFormat:@"%.2f", discount.maxDiscount]];
        [currentDiscountString appendElement:@"CARDHOLDER" withText:discount.cardholder];
        [currentDiscountString appendElement:@"DISCSUMM" withText:[NSString stringWithFormat:@"%.2f", discount.discountAmountRub]];
        [currentDiscountString appendElement:@"EDITABLEVALUE" withText:discount.editable ? @"true":@"false"];
        [currentDiscountString appendElement:@"DISABLED" withText:discount.enabled ? @"false":@"true"];
        
        [mutableString appendElement:@"Items" withText:currentDiscountString];
    }
    
    [mutableString appendString:@"</ArrayOfItemsLOYALTY>"];
    
    return mutableString;
}

- (void) run: (NSString*) url
{
    // Check input parameters:
    if ( _receiptID == Nil )
    {
        [Logger log:self method:@"run" format:@"'receiptID' property is not set"];
        [self complete:NO];
        return;
    }
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[NwRequest alloc] init];
    // NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:_cartData options:0 error:nil];
    //NSString *string = [[NSString alloc] initWithData:dataToSend encoding:NSUTF8StringEncoding];
    //#if RIVGOSH
    //
    //    nwReq.URL = [NSMutableString stringWithFormat:@"%@/client/?barcode=%@", url, _cardNumber ];
    //#else
    NSString* uuid = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringToIndex:12];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/WriteOffReq/%@/?id=%@",url, uuid, _receiptID];
    //#endif
    nwReq.httpMethod = HTTP_METHOD_POST;
    nwReq.rawBody = [self serializeDiscounts];
    //[nwReq addParam:@"value" withValue:string];
    //[nwReq addParam:@"password" withValue:[_userPassword sha256]];
#if TARGET_IPHONE_SIMULATOR
    //[nwReq addParam:@"device_id" withValue:@"123456789Simulator"];
    //running on device
#else
    //[nwReq addParam:@"device_id" withValue:[UIDevice currentDevice].identifierForVendor.UUIDString];
#endif
    
    
    NSURLRequest *__exec_request = [nwReq buildURLRequest];
    
    //[__exec_request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
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
        
       // id obj = nil;
        
        
        if ( _resultCode == 0 )
        {
            [self rivGoshParser:result];
            return;
        }
        else
        {
            id obj = [result objectForKey:@"data"];
            if (obj && [obj isKindOfClass:[NSString class]])
                [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"NetworkErrorDescription"];
            else
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"NetworkErrorDescription"];
        }

        
        //[dataString release];
    }
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate applyDiscountsComplete:_resultCode items:nil];
}

- (void) rivGoshParser:(NSDictionary*) result
{
    
    ItemInformation *itemInfo = nil;
    NSMutableArray *finalItemsArray = [NSMutableArray new];
    id obj = [result objectForKey:@"data"];
    if (obj && [obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *data = obj;
        
        obj = [data objectForKey:@"DTL"];
        if (obj && [obj isKindOfClass:[NSArray class]])
        {
            NSArray *dtl = obj;
            for (NSDictionary *dictParams in dtl) {
                
                
                itemInfo = [ItemInformation new];
                NSMutableArray *additionalParams = [NSMutableArray new];
                
                    obj = [dictParams objectForKey:@"Цена"];
                    if (obj && [obj isKindOfClass:[NSNumber class]])
                        itemInfo.price = [obj doubleValue];
                    obj = [dictParams objectForKey:@"Номенклатура"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        itemInfo.name = obj;
                    obj = [dictParams objectForKey:@"Номенклатура_Код"];
                    if (obj && [obj isKindOfClass:[NSNumber class]])
                        itemInfo.itemId = [obj integerValue];
                    obj = [dictParams objectForKey:@"СерийныйНомер"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        itemInfo.article = obj;
                    obj = [dictParams objectForKey:@"УИДСтроки"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                    {
                        ParameterInformation *param = [ParameterInformation new];
                        param.name = @"uid";
                        param.value = obj;
                        [additionalParams addObject:param];
                    }
                obj = [dictParams objectForKey:@"Количество"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                {
                    ParameterInformation *param = [ParameterInformation new];
                    param.name = @"quantity";
                    param.value = [NSString stringWithFormat:@"%ld", (long)[obj integerValue]];
                    [additionalParams addObject:param];
                }
                
                
                obj = [dictParams objectForKey:@"Скидки"];
                if (obj && [obj isKindOfClass:[NSArray class]])
                {
                    ParameterInformation *param = [ParameterInformation new];
                    param.name = @"discounts";
                    param.value = obj;
                    [additionalParams addObject:param];
                }
                
                itemInfo.additionalParameters = additionalParams;
                [finalItemsArray addObject:itemInfo];
            }
        }
        
        /*obj = [data objectForKey:@"HDR"];
        if (obj && [obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* HDR = obj;
            obj = [HDR objectForKey:@"Id"];
            if (obj && [obj isKindOfClass:[NSString class]])
            {
                ParameterInformation *param = [ParameterInformation new];
                param.name = @"ReceiptID";
                param.value = obj;
                [additionalParams addObject:param];
            }
        } */
        
    }
    
    if ( _delegate )
        [_delegate applyDiscountsComplete:_resultCode items:finalItemsArray];
}




@end
