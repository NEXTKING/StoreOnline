//
//  AcceptanesInformation.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 17/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInformation.h"

typedef enum : NSUInteger
{
    AcceptanesInformationItemTypeBox = (1 << 0),
    AcceptanesInformationItemTypeSet = (1 << 1),
    AcceptanesInformationItemTypeItem = (1 << 2)
}AcceptanesInformationItemType;

@interface AcceptanesInformation : NSObject

@property (nonnull, nonatomic, copy) NSString *barcode;
@property (nonnull, nonatomic, copy) NSString *containerBarcode;
@property (nonnull, nonatomic, copy) NSNumber *quantity;
@property (nonnull, nonatomic, copy) NSNumber *scanned;
@property (nonnull, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic) ItemInformation *itemInformation;
@property (assign, nonatomic) AcceptanesInformationItemType type;
@property (assign, nonatomic) BOOL manually;

@property (assign, nonatomic) BOOL isComplete;
@property (nonnull, nonatomic, copy) NSNumber *ID;
@property (nonnull, nonatomic, copy) NSString *shopName;
@end
