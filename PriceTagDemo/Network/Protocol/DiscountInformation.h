//
//  DiscountInformation.h
//  PriceTagDemo
//
//  Created by denis on 12.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountInformation : NSObject

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* card;
@property (nonatomic, copy) NSString* cardholder;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) double maxDiscount;
@property (nonatomic, assign) double discountAmountRub;
@property (nonatomic, assign) double discountAmountPoints;
@property (nonatomic, assign) double sumBalance;
@property (nonatomic, assign) NSInteger bonusBalance;
//@property (nonatomic, )

@end
