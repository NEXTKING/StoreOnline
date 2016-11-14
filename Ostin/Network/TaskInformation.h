//
//  TaskInformation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 10/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPOperation.h"
#import "TaskItemInformation.h"

typedef enum : NSUInteger
{
    TaskInformationStatusNotStarted = 0,
    TaskInformationStatusInProgress = 1,
    TaskInformationStatusComplete = 2
}TaskInformationStatus;

@interface TaskInformation : NSObject

@property (nonatomic, assign) NSInteger taskID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger totalPrintedCount;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSArray<TaskItemInformation *> *items;

@end
