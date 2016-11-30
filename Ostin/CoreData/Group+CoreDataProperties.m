//
//  Group+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "Group+CoreDataProperties.h"

@implementation Group (CoreDataProperties)

+ (NSFetchRequest<Group *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Group"];
}

@dynamic groupID;
@dynamic groupTitle;

@end
