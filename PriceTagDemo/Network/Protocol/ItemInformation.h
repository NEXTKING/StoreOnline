//
//  ItemInformation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21.01.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiscountInformation.h"

@interface ParameterInformation : NSObject <NSCoding>
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* value;

- (instancetype)initWithName:(NSString *)name value:(NSString *)value;

@end

@interface ItemInformation : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* article;
@property (nonatomic, copy) NSString* barcode;
@property (nonatomic, copy) NSString* imageName;
@property (nonatomic, copy) NSString* color;
@property (nonatomic, copy) NSString* material;
@property (nonatomic, copy) NSNumber* length;
@property (nonatomic, copy) NSNumber* width;
@property (nonatomic, copy) NSNumber* height;
@property (nonatomic, copy) NSNumber* diameter;
@property (nonatomic, copy) NSString* unit;
@property (nonatomic, strong) NSArray* warehouses;
@property (nonatomic, strong) NSDictionary* additionalParameters;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) NSInteger stock;

//Rivgosh
@property (nonatomic, strong) NSArray<DiscountInformation*>* appliedDiscounts;

@end
