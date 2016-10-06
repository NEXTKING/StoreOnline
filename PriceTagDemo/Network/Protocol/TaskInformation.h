//
//  TaskInformation.h
//  Checklines
//
//  Created by Denis Kurochkin on 19.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TasksType
{
    AssignedTasks = 0,
    VacantTask = 1,
    PendingTask = 2,
    AcceptedTast = 3,
    RejectedTask = 4,
    UnknownTasks = 5
}TasksType;

@interface TaskInformation : NSObject

@property (nonatomic, copy) NSString* taskId;
@property (nonatomic, copy) NSString* taskInworkId;
@property (nonatomic, copy) NSString* taskName;
@property (nonatomic, copy) NSString* clientName;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger experience;
@property (nonatomic, assign) double points;
@property (nonatomic, copy, readonly) NSDate* finishDateTime;
@property (nonatomic, assign) double distance;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString* taskDescription;
@property (nonatomic, copy) NSString* comment;
@property (nonatomic, assign) TasksType type;

//Detailed information
@property (nonatomic, retain, readonly) NSDate* startDateTime;
@property (nonatomic, retain) NSArray *blanks;
@property (nonatomic, retain) NSArray* photos;
@property (nonatomic, retain) NSArray* quizes;
@property (nonatomic, retain) NSArray* reports;

//Done task
@property (nonatomic, retain, readonly) NSDate* takeDateTime;
@property (nonatomic, retain, readonly) NSDate* endDateTime;

//Checked task
@property (nonatomic, retain, readonly) NSDate* checkDateTime;

- (void) setStartDateFromString:(NSString*)startDate;
- (void) setFinishDateFromString:(NSString*)finishDate;
- (void) setTakeDateFromString:(NSString*)takeDate;
- (void) setEndDateFromString:(NSString*)endDate;
- (void) setCheckDateFromString:(NSString*)checkDate;

- (void) clearAnswers;

@end
