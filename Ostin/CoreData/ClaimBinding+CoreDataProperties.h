//
//  ClaimBinding+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 26/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "ClaimBinding+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClaimBinding (CoreDataProperties)

+ (NSFetchRequest<ClaimBinding *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *claimBindingID;
@property (nullable, nonatomic, copy) NSNumber *claimID;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSNumber *quantity;

@end

NS_ASSUME_NONNULL_END
