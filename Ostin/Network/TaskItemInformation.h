//
//  TaskItemInformation.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 13/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInformation.h"

@interface TaskItemInformation : NSObject

@property (nonatomic, assign) NSUInteger itemID;
@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, assign) NSUInteger scanned;

@end
