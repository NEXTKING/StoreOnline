//
//  ItemPrintFact+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 21/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ItemPrintFact+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ItemPrintFact (CoreDataProperties)

+ (NSFetchRequest<ItemPrintFact *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *taskName;
@property (nullable, nonatomic, copy) NSString *itemCode;
@property (nullable, nonatomic, copy) NSNumber *wasUploaded;

@end

NS_ASSUME_NONNULL_END
