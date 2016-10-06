//
//  Item+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 9/2/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *article;
@property (nullable, nonatomic, retain) NSString *barcode;
@property (nullable, nonatomic, retain) NSNumber *itemId;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSNumber* stock;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *additionalParams;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addAdditionalParamsObject:(NSManagedObject *)value;
- (void)removeAdditionalParamsObject:(NSManagedObject *)value;
- (void)addAdditionalParams:(NSSet<NSManagedObject *> *)values;
- (void)removeAdditionalParams:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
