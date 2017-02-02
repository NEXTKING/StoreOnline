//
//  StockGroup.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 02/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInformation.h"

@interface StockGroup : NSObject

- (instancetype)initWithItems:(NSArray<ItemInformation*>*)items;

- (NSString *)title;
- (NSString *)article;

- (NSArray<NSString*>*)sizes;
- (NSArray<NSString*>*)colors;

- (NSArray<NSString*>*)colorsForSize:(NSString*)size;
- (NSArray<NSString*>*)sizesForColor:(NSString*)color;

- (NSUInteger)countForSize:(NSString*)size color:(NSString *)color;
- (NSUInteger)totalCount;

@end
