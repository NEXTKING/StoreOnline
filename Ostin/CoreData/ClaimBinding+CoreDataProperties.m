//
//  ClaimBinding+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 26/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ClaimBinding+CoreDataProperties.h"

@implementation ClaimBinding (CoreDataProperties)

+ (NSFetchRequest<ClaimBinding *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ClaimBinding"];
}

@dynamic claimBindingID;
@dynamic claimID;
@dynamic itemID;
@dynamic quantity;
@dynamic scanned;
@dynamic cancelReason;

@end
