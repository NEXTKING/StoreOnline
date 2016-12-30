//
//  Claim+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 26/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Claim+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Claim (CoreDataProperties)

+ (NSFetchRequest<Claim *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *claimID;
@property (nullable, nonatomic, copy) NSString *claimNumber;
@property (nullable, nonatomic, copy) NSNumber *userID;
@property (nullable, nonatomic, copy) NSDate *incomingDate;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSDate *endDate;

@end

NS_ASSUME_NONNULL_END
