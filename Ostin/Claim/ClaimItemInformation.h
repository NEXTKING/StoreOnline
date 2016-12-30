//
//  ClaimItemInformation.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcceptancesProtocol.h"
#import "ItemInformation.h"

@interface ClaimItemInformation : NSObject <AcceptancesItem>

@property (nonatomic, readonly) NSNumber *claimBindingID;
@property (nonatomic, readonly) NSString *cancelReason;

- (instancetype)initWithClaimBindingID:(NSNumber *)claimBindingID itemInformation:(ItemInformation *)itemInformation totalCount:(NSNumber *)total scannedCount:(NSNumber *)scanned cancelReason:(NSString *)cancelReason;

@end
