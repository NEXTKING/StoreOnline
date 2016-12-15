//
//  CloseDayOperation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 12/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloseDayOperation : NSOperation

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSError* error;
@property (nonatomic, copy) NSNumber* dbAmount;

@end
