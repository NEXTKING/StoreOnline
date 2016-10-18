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
    else
        return barcodeString;
}

@end
