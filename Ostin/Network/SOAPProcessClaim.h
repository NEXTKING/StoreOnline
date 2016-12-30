//
//  SOAPProcessClaim.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 28/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPOperation.h"

@interface SOAPProcessClaim : NSOperation

@property (nonatomic, copy) NSArray* claimItems;
@property (nonatomic, copy) NSString* claimID;
@property (nonatomic, copy) NSString* authValue;
@property (nonatomic, copy) NSString* deviceID;
@property (nonatomic, copy) NSString* userID;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString* errorMessage;

@end
