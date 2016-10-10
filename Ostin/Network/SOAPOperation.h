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

@interface SOAPOperation : NSOperation
{
@protected
    NSInteger numberOfPortions;
    NSInteger currentPortionID;
    NSString *_incValue;
}

@property (nonatomic, strong) CoreDataController* dataController;
@property (nonatomic, copy) NSString* authValue;
@property (nonatomic, assign) BOOL success;

- (NSArray*) downloadItems;
- (BOOL) saveItems: (NSArray*) items;

- (NSInteger) getPortions:(NSString*) code;
- (BOOL) commitPortion:(NSString*) incCode portionID:(NSNumber*) portion;
- (NSArray*) removeQuotes:(NSArray*) values;

@end
