//
//  SOAPSavePrintFact.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 20/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPOperation.h"
#import "TaskItemInformation.h"

@interface SOAPSavePrintFact : NSOperation

@property (nonatomic, copy) NSArray<TaskItemInformation *>* items;
@property (nonatomic, copy) NSString* taskName;
@property (nonatomic, copy) NSString* authValue;
@property (nonatomic, copy) NSString* deviceID;
@property (nonatomic, assign) BOOL success;

@end
