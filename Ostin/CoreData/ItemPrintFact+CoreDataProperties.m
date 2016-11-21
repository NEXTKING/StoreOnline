//
//  ItemPrintFact+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 21/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ItemPrintFact+CoreDataProperties.h"

@implementation ItemPrintFact (CoreDataProperties)

+ (NSFetchRequest<ItemPrintFact *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ItemPrintFact"];
}

@dynamic taskName;
@dynamic itemCode;
@dynamic wasUploaded;

@end
