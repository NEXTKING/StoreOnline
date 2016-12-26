//
//  BarcodeFormatter.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 18/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "BarcodeFormatter.h"
#import "DTDevices.h"

@implementation BarcodeFormatter

+ (NSString *)normalizedBarcodeFromString:(NSString *)barcodeString isoType:(int)type
{
    if (type == BAR_UPC && barcodeString.length>=12)
    {
        NSString *string = [NSString stringWithFormat:@"0%@", barcodeString];
        
        if ([string hasPrefix:@"09900"])
        {
            NSString *substring = [string substringFromIndex:5];
            NSString *substring1 = [substring substringToIndex:substring.length-1];
            
            return substring1;
        }
        else
        {
            NSString* substring = [string substringToIndex:11];
            
            return substring;
        }
    }
    else if (type == BAR_CODE128 && barcodeString.length >=25)
    {
        NSString *barcode = [barcodeString substringWithRange:NSMakeRange(barcodeString.length - 17, 7)];
        
        return barcode;
    }
    else
        return barcodeString;
}

+ (NSString *) generateCode128WithShopID:(NSString*)shopID code:(NSString*)code price:(double) price
{
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"ddMM"];
    NSDate* currentDate = [NSDate date];
    
    NSString* dayMonthString = [dateFormatter stringFromDate:currentDate];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString* yearString     = [dateFormatter stringFromDate:currentDate];
    NSString* lastYearSymbol = [yearString substringFromIndex:3];
    NSString* dateString = [NSString stringWithFormat:@"%@%@", dayMonthString,lastYearSymbol];
    
    NSString* priceString = [NSString stringWithFormat:@"%010.0f", price*100];
    
    return [NSString stringWithFormat:@"%@%@%@%@", shopID, dateString, code, priceString];
}

+ (NSDictionary *)dataFromBarcode:(NSString *)barcodeString isoType:(int)type
{
    if (type == BAR_CODE128 && barcodeString.length >=25)
    {
        NSString *rawPrice = [barcodeString substringWithRange:NSMakeRange(barcodeString.length - 10, 10)];
        NSString *barcode = [barcodeString substringWithRange:NSMakeRange(barcodeString.length - 17, 7)];
        NSString *date = [barcodeString substringWithRange:NSMakeRange(barcodeString.length - 22, 5)];
        NSString *shopNumber = [barcodeString substringWithRange:NSMakeRange(0, barcodeString.length - rawPrice.length - barcode.length - date.length)];
        
        NSString *price = [@([rawPrice doubleValue] / 100) stringValue];
        
        return @{@"shopNumber":shopNumber, @"date":date, @"barcode":barcode, @"price":price};
    }
    return nil;
}

@end
