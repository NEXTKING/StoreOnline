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
    #ifdef OSTIN
    else if (type == BAR_CODE128 && barcodeString.length >=26)
    {
        NSString *barcode = [barcodeString substringWithRange:NSMakeRange(9, 7)];
        
        return barcode;
    }
    #endif
    else
        return barcodeString;
}

+ (NSDictionary *)dataFromBarcode:(NSString *)barcodeString isoType:(int)type
{
    #ifdef OSTIN
    if (type == BAR_CODE128 && barcodeString.length >=26)
    {
        NSString *shopNumber = [barcodeString substringToIndex:4];
        NSString *date = [barcodeString substringWithRange:NSMakeRange(4, 5)];
        NSString *barcode = [barcodeString substringWithRange:NSMakeRange(9, 7)];
        NSString *rawPrice = [barcodeString substringFromIndex:16];
        NSString *price = [@([rawPrice doubleValue] / 100) stringValue];
        
        return @{@"shopNumber":shopNumber, @"date":date, @"barcode":barcode, @"price":price};
    }
    #endif
    return nil;
}

@end
