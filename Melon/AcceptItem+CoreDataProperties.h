//
//  AcceptItem+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 16/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AcceptItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AcceptItem (CoreDataProperties)

+ (NSFetchRequest<AcceptItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *barcode;
@property (nullable, nonatomic, copy) NSString *containerBarcode;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSNumber *quantity;
@property (nullable, nonatomic, copy) NSNumber *scanned;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSNumber *manually;

@end

NS_ASSUME_NONNULL_END
