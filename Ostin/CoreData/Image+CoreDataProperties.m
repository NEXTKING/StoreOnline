//
//  Image+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "Image+CoreDataProperties.h"

@implementation Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Image"];
}

@dynamic itemID;
@dynamic fileID;
@dynamic filename;

@end
