//
//  BarcodeFormatter.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 18/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarcodeFormatter : NSObject
+ (NSString *) normalizedBarcodeFromString:(NSString *)barcodeString isoType:(int)type;
+ (NSString *) generateCode128WithShopID:(NSString*)shopID code:(NSString*)code price:(double) price;
@end
