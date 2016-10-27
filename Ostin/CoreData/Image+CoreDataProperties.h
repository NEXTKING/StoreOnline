//
//  Image+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "Image+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest;

@property (nonatomic) int64_t itemID;
@property (nonatomic) int64_t fileID;
@property (nullable, nonatomic, copy) NSString *filename;

@end

NS_ASSUME_NONNULL_END
