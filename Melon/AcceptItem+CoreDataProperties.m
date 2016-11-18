//
//  AcceptItem+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 16/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AcceptItem+CoreDataProperties.h"

@implementation AcceptItem (CoreDataProperties)

+ (NSFetchRequest<AcceptItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AcceptItem"];
}

@dynamic barcode;
@dynamic containerBarcode;
@dynamic type;
@dynamic quantity;
@dynamic scanned;
@dynamic date;
@dynamic manually;

@end
