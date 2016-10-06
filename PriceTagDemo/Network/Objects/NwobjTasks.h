//
//  NwobjTasks.h
//  Checklines
//
//  Created by Denis Kurochkin on 19.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"
#import "TaskInformation.h"



@interface NwobjTasks : NwObject

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <TasksDelegate> delegate;
@property (nonatomic, assign) TasksType type;
@property (nonatomic, assign) BOOL shouldUseAddress;

// input parameters:
@property (nonatomic, readwrite, copy) NSString* userId;
@property (nonatomic, readwrite, copy) NSString* userSession;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readonly, retain) NSMutableArray *tasks;


@end
