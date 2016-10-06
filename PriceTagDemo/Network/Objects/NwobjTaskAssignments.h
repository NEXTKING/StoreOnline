//
//  NwobjTaskAssignments.h
//  Checklines
//
//  Created by Denis Kurochkin on 05.11.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"
#import <CoreLocation/CoreLocation.h>

typedef enum AssignmentType
{
    ATAddTask = 0,
    ATRemoveTask = 1,
    ATUploadTask = 2,
    ATUnknown = 3
}AssignmentType;

@interface NwobjTaskAssignments : NwObject

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <TaskAssignmentsDelegate> delegate;
@property (nonatomic, assign) AssignmentType type;

// input parameters:
@property (nonatomic, readwrite, copy) NSString* userId;
@property (nonatomic, readwrite, copy) NSString* userSession;
@property (nonatomic, copy) NSString*taskId;
@property (nonatomic, retain) TaskInformation *taskInfo;
@property (nonatomic, assign) CLLocationCoordinate2D coorditane;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@end
