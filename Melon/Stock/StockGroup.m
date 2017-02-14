//
//  StockGroup.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 02/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "StockGroup.h"

@interface StockGroup()
@property (strong, nonatomic) NSArray<ItemInformation*>*items;
@end

@implementation StockGroup

- (instancetype)initWithItems:(NSArray<ItemInformation*>*)items
{
    self = [super init];
    if (self)
    {
        self.items = items;
    }
    return self;
}

- (NSString *)title
{
    return self.items.firstObject.name;
}

- (NSString *)article
{
    return self.items.firstObject.article;
}

- (NSArray<NSString*>*)sizes
{
    NSMutableSet *sizesSet = [NSMutableSet new];
    
    for (ItemInformation *item in self.items)
    {
        if (item.additionalParameters && item.additionalParameters[@"Size"] && [item.additionalParameters[@"Size"] isKindOfClass:[NSString class]])
        {
            if (item.stock > 0)
                [sizesSet addObject:item.additionalParameters[@"Size"]];
        }
    }
    return [[sizesSet allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSString *s1, NSString *s2) {
        NSArray *parts1 = [s1 componentsSeparatedByString:@"-"];
        NSArray *parts2 = [s2 componentsSeparatedByString:@"-"];
        if (parts1.count > 2 && parts2.count > 2)
            return [parts1[1] compare:parts2[1] options:NSNumericSearch];
        else
            return [s1 compare:s2];
    }];
}

- (NSArray<NSString*>*)colors
{
    return nil;
}

- (NSArray<NSString*>*)colorsForSize:(NSString*)size
{
    NSMutableSet *colorsSet = [NSMutableSet new];
    
    for (ItemInformation *item in self.items)
    {
        if (item.additionalParameters && item.color)
        {
            if (item.additionalParameters[@"Size"] && [item.additionalParameters[@"Size"] isEqualToString:size])
            {
                [colorsSet addObject:item.color];
            }
        }
    }
    return [colorsSet allObjects];
}

- (NSArray<NSString*>*)sizesForColor:(NSString*)color
{
    return nil;
}

- (NSUInteger)countForSize:(NSString*)size color:(NSString *)color
{
    NSUInteger count = 0;
    
    for (ItemInformation *item in self.items)
    {
        if (item.additionalParameters && item.additionalParameters[@"Size"] && [item.additionalParameters[@"Size"] isEqualToString:size])
        {
            if (color)
            {
                if (item.color && [item.color isEqualToString:color])
                    count = count + item.stock;
            }
            else
                count = count + item.stock;
        }
    }
    return count;
}

- (NSUInteger)totalCount
{
    NSUInteger count = 0;
    
    for (ItemInformation *item in self.items)
        count = count + item.stock;
    
    return count;
}

@end
