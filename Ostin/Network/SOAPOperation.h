//
//  SOAPOperation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 08/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PI_MOBILE_SERVICEService.h"
#import "CoreDataController.h"

@interface SOAPOperation : NSOperation <NSProgressReporting>
{
@protected
    NSInteger numberOfPortions;
    NSInteger currentPortionID;
}

//Progress protocol
@property (nonatomic, strong) NSProgress *progress;

@property (nonatomic, strong) CoreDataController* dataController;
@property (nonatomic, copy) NSString* authValue;
@property (nonatomic, copy) NSString* deviceID;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSManagedObjectContext* privateContext;
@property (nonatomic, copy) NSString* incValue;
@property (nonatomic, copy) NSString* coreDataId;

- (NSArray*) downloadItems;
- (NSManagedObject*) findObject:(NSArray*) csv;
- (void) updateObject:(NSManagedObject*) obj csv:(NSArray*) csv;

- (NSInteger) getPortions:(NSString*) code;
- (BOOL) commitPortion:(NSString*) incCode portionID:(NSNumber*) portion;
- (NSArray*) removeQuotes:(NSArray*) values;

@end
