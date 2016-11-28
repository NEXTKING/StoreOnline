//
//  Item+CoreDataProperties.m
//  
//
//  Created by Denis Kurochkin on 07/10/2016.
//
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

@dynamic additionalInfo;
@dynamic additionalSize;
@dynamic barcode;
@dynamic boxType;
@dynamic certificationAuthorittyCode;
@dynamic certificationType;
@dynamic collection;
@dynamic color;
@dynamic drop;
@dynamic groupID;
@dynamic itemCode;
@dynamic itemCode_2;
@dynamic itemID;
@dynamic line1;
@dynamic line2;
@dynamic name;
@dynamic priceHeader;
@dynamic size;
@dynamic sizeHeader;
@dynamic storeNumber;
@dynamic subgroupID;
@dynamic trademarkID;

@end
