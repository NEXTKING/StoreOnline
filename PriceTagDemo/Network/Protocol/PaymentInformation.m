//
//  PaymentInformation.m
//  Checklines
//
//  Created by Denis Kurochkin on 12/17/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import "PaymentInformation.h"

@implementation PaymentInformation

- (void) dealloc
{
    [_date release];
    [super dealloc];
}

@end
