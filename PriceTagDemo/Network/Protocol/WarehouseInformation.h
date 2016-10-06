//
//  WarehouseInformation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 20.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarehouseInformation : NSObject <NSCoding>

@property (nonatomic, assign)   NSInteger wid;
@property (nonatomic, copy)     NSString* name;
@property (nonatomic, assign)   NSInteger count;
@property (nonatomic, assign)   NSInteger reservedCount;

@end
