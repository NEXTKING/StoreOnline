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

@property (nonatomic) double catalogPrice;
@property (nonatomic) double retailPrice;
@property (nullable, nonatomic, retain) Item *item;

@end

NS_ASSUME_NONNULL_END
