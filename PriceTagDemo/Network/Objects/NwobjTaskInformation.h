//
//  NwobjTaskInformation.h
//  Checklines
//
//  Created by Kurochkin on 29/10/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjTaskInformation : NwObject

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <TaskInfoDelegate> delegate;

// input parameters:
@property (nonatomic, readwrite, copy) NSString* userId;
@property (nonatomic, readwrite, copy) NSString* userSession;
@property (nonatomic, copy) NSString*taskId;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readonly, retain) TaskInformation *taskInfo;

@end
