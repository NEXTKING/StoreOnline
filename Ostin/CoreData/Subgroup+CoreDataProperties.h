//
//  Subgroup+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "Subgroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Subgroup (CoreDataProperties)

+ (NSFetchRequest<Subgroup *> *)fetchRequest;

@property (nonatomic) int64_t subgroupID;
@property (nullable, nonatomic, copy) NSString *subgroupTitle;

@end

NS_ASSUME_NONNULL_END
