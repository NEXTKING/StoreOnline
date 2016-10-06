//
//  CoreDataController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 9/2/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataController : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;

- (void)initializeCoreData;
- (void)recreatePersistentStore;

@end
