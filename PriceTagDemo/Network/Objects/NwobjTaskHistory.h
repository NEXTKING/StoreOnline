//
//  NwobjTaskHistory.h
//  Checklines
//
//  Created by Kurochkin on 05/11/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjTaskHistory : NwObject

typedef enum HistoryType
{
    DoneTasks = 0,
    CheckedTasks = 1
}HistoryType;


- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <TaskHistoryDelegate> delegate;
@property (nonatomic, assign) HistoryType type;

// input parameters:
@property (nonatomic, readwrite, copy) NSString* userId;
@property (nonatomic, readwrite, copy) NSString* userSession;


// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (retain) NSMutableArray *doneTasks;
@property (retain) NSMutableArray *checkedTasks;


@end
