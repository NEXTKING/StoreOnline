//
//  Claim+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 26/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Claim+CoreDataProperties.h"

@implementation Claim (CoreDataProperties)

+ (NSFetchRequest<Claim *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Claim"];
}

@dynamic claimID;
@dynamic claimNumber;
@dynamic userID;
@dynamic incomingDate;

@end
