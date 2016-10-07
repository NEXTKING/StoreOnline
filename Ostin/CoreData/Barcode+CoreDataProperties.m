//
//  Barcode+CoreDataProperties.m
//  
//
//  Created by Denis Kurochkin on 07/10/2016.
//
//

#import "Barcode+CoreDataProperties.h"

@implementation Barcode (CoreDataProperties)

+ (NSFetchRequest<Barcode *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Barcode"];
}

@dynamic code128;
@dynamic ean;
@dynamic item;
@dynamic itemID;

@end
