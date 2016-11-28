//
//  MCPSimulatorImpl+RivGosh.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MCPSimulatorImpl+RivGosh.h"

#ifndef DEBUG
static const double _network_delay = 1.0;
#else
static const double _network_delay = 1.0;
#endif

@interface MCPSimulatorImpl_RivGosh ()
{
    NSMutableArray *currentItems;
    BOOL isDiscountApplied;
}

@end

@implementation MCPSimulatorImpl_RivGosh

- (void) generateData
{
    [super generateData];
    currentItems = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanNotificationHandler:) name:@"CleanAllData" object:nil];
}

- (void) cleanNotificationHandler:(NSNotification*) notification
{
    [self cleanUpData];
}

- (void) clinetCard:(id<ClientCardDelegate>)delegate cardNumber:(NSString *)card
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        isDiscountApplied = YES;
        if ([card isEqualToString:@"15769996"])
            [delegate clientCardComplete:0 description:@"Скидка 10% применена" hint:nil receiptID:nil];
        else
            [delegate clientCardComplete:1 description:nil hint:nil receiptID:nil];
    });
    
}

- (void) cleanUpData
{
    [currentItems removeAllObjects];
    isDiscountApplied = NO;
}

- (void) addItemToCurrent:(ItemInformation*) item
{
    ItemInformation* found = nil;
    for (ItemInformation* i in currentItems) {
        if ([item.barcode isEqualToString:i.barcode])
        {
            found = i;
            break;
        }
    }
    
    if (found)
    {
        NSInteger quan = 0;
        for (ParameterInformation* p in found.additionalParameters) {
            if ([p.name isEqualToString:@"quantity"])
                quan = [p.value integerValue];
        }
        
        ParameterInformation* param = [[ParameterInformation alloc] initWithName:@"quantity" value:[NSString stringWithFormat:@"%ld",(long)quan+1]];
        found.additionalParameters = @[param];
    }
    else
    {
        ParameterInformation* param = [[ParameterInformation alloc] initWithName:@"quantity" value:@"1"];
        item.additionalParameters = @[param];
        [currentItems addObject:[_itemsDictionary objectForKey:item.barcode]];
    }
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode isoType:(int)type
{
    if (code != nil && [_itemsDictionary objectForKey:code])
    {
        [self addItemToCurrent:[_itemsDictionary objectForKey:code]];
    }
    [super itemDescription:delegate itemCode:code shopCode:shopCode isoType:type];
}

- (void) discounts:(id<DiscountsDelegate>)delegate receiptId:(NSString *)receiptID
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_network_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [delegate discountsComplete:0 discounts:nil];
    });
}

- (void) applyDiscounts:(id<ApplyDiscountsDelegate>)delegate discounts:(NSArray *)discounts receiptId:(NSString *)rid
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_network_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (isDiscountApplied)
        {
            for (ItemInformation* item in currentItems) {
                
                if ([self hasDiscount:item])
                    continue;
                
                ParameterInformation* param = [ParameterInformation new];
                param.name = @"discounts";
                param.value = @[@{@"Сумма":@(-item.price*0.1)}];
                NSMutableArray* paramsArray = [[NSMutableArray alloc] initWithArray:item.additionalParameters];
                [paramsArray addObject:param];
                item.additionalParameters = paramsArray;
            }
        }
        
        [delegate applyDiscountsComplete:0 items:currentItems];
    });
}

- (BOOL) hasDiscount:(ItemInformation*) item
{
    for (ParameterInformation *param in item.additionalParameters) {
        if ([param.name isEqualToString:@"discounts"])
            return YES;
    }
    
    return NO;
}

- (void) printStatus:(id<PrinterDelegate>)delegate receiptId:(NSString *)receiptId
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_network_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PrinterStatus* status = [PrinterStatus new];
        status.fiscalStatus = YES;
        status.queueStatus = YES;
        
        [delegate printStatusComplete:0 detailedDescription:status];
    });
}

- (void) sendPayment:(id<SendPaymentDelegate>)delegate amount:(double)amount authCode:(NSString *)authCode transactionCode:(NSString *)transactionCode card:(NSString *)card receiptId:(NSString *)receiptId
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_network_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [delegate sendPaymentComplete:0];
    });
}

- (void) sendLoyalty:(id<SendPaymentDelegate>)delegate receiptId:(NSString *)receiptId
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_network_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [delegate sendLoyaltyComplete:0];
    });
}

@end
