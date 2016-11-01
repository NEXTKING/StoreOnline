//
//  Item+CoreDataProperties.h
//  
//
//  Created by Denis Kurochkin on 07/10/2016.
//
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *additionalInfo;
@property (nullable, nonatomic, copy) NSString *additionalSize;
@property (nullable, nonatomic, copy) NSString *barcode;
@property (nullable, nonatomic, copy) NSString *boxType;
@property (nullable, nonatomic, copy) NSString *certificationAuthorittyCode;
@property (nullable, nonatomic, copy) NSString *certificationType;
@property (nullable, nonatomic, copy) NSString *collection;
@property (nullable, nonatomic, copy) NSString *color;
@property (nullable, nonatomic, copy) NSString *drop;
@property (nullable, nonatomic, copy) NSNumber *groupID;
@property (nullable, nonatomic, copy) NSString *itemCode;
@property (nullable, nonatomic, copy) NSString *itemCodeOstin;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSString *line1;
@property (nullable, nonatomic, copy) NSString *line2;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *priceHeader;
@property (nullable, nonatomic, copy) NSString *size;
@property (nullable, nonatomic, copy) NSString *sizeHeader;
@property (nullable, nonatomic, copy) NSString *storeNumber;
@property (nonatomic, copy) NSNumber* subgroupID;
@property (nonatomic, copy) NSNumber* trademarkID;

@end

NS_ASSUME_NONNULL_END
