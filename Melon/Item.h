//
//  Item.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 9/2/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

- (void) setAdditionalParameters:(NSDictionary*) params;

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
