//
//  Item+CoreDataClass.h
//  
//
//  Created by Denis Kurochkin on 07/10/2016.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Barcode, Price;

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
