//
//  PaymentInformation.h
//  Checklines
//
//  Created by Denis Kurochkin on 12/17/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PaymentStatus
{
    PSPending = 0,
    PSCompleted = 1,
    PSDeclined = 2
}PaymentStatus;

@interface PaymentInformation : NSObject

@property (nonatomic, copy) NSDate* date;
@property (nonatomic, assign) double amount;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) PaymentStatus status;


@end
