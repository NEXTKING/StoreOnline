//
//  ZReport.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZReport : NSObject

@property (nonatomic, copy) NSNumber* dbAmount;
@property (nonatomic, copy) NSNumber* fiscalAmount;
@property (nonatomic, copy)   NSString* receiptID;

@property (nonatomic, strong) NSArray* items;

@end
