//
//  SOAPResetIncDone.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 10/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPOperation.h"

@interface SOAPResetIncDone : NSOperation

@property (nonatomic, copy) NSString* authValue;
@property (nonatomic, copy) NSString* deviceID;
@property (nonatomic, assign) BOOL success;

@end
