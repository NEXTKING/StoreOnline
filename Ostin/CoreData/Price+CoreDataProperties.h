//
//  Price+CoreDataProperties.h
//  
//
//  Created by Denis Kurochkin on 07/10/2016.
//
//

#import "Price+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Price (CoreDataProperties)

+ (NSFetchRequest<Price *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *catalogPrice;
@property (nullable, nonatomic, copy) NSNumber *retailPrice;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSNumber *discount;

@end

NS_ASSUME_NONNULL_END
