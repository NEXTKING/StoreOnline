//
//  Subgroup+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "Subgroup+CoreDataProperties.h"

@implementation Subgroup (CoreDataProperties)

+ (NSFetchRequest<Subgroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Subgroup"];
}

@dynamic subgroupID;
@dynamic subgroupTitle;

@end
