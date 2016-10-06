//
//  AdditionalParameter+CoreDataProperties.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 9/2/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AdditionalParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdditionalParameter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *value;

@end

NS_ASSUME_NONNULL_END
