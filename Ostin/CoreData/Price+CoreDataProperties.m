//
//  Price+CoreDataProperties.m
//  
//
//  Created by Denis Kurochkin on 07/10/2016.
//
//

#import "Price+CoreDataProperties.h"

@implementation Price (CoreDataProperties)

+ (NSFetchRequest<Price *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Price"];
}

@dynamic catalogPrice;
@dynamic dateModified;
@dynamic retailPrice;
@dynamic itemID;
@dynamic discount;

@end
