//
//  ClaimItem.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcceptancesProtocol.h"
#import "ItemInformation.h"

@interface ClaimItem : NSObject <AcceptancesItem>

@property (nonatomic, readonly) NSNumber *claimID;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

- (instancetype)initWithClaimID:(NSNumber *)claimID claimNumber:(NSString *)claimNumber incomingDate:(NSDate *)incomingDate startDate:(NSDate *)startDate endDate:(NSDate *)endDate userID:(NSNumber *)userID;

@end
