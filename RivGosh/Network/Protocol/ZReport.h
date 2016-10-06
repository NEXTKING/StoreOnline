//
//  ZReport.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZReport : NSObject

@property (nonatomic, assign) double dbAmount;
@property (nonatomic, assign) double fiscalAmount;
@property (nonatomic, copy)   NSString* receiptID;

@property (nonatomic, strong) NSArray* items;

@end
