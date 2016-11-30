//
//  Group+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "Group+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Group (CoreDataProperties)

+ (NSFetchRequest<Group *> *)fetchRequest;

@property (nonatomic) int64_t groupID;
@property (nullable, nonatomic, copy) NSString *groupTitle;

@end

NS_ASSUME_NONNULL_END
