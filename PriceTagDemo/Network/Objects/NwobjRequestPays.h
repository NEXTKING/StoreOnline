//
//  NwobjRequestPays.h
//  Checklines
//
//  Created by Denis Kurochkin on 4/20/15.
//  Copyright (c) 2015 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjRequestPays : NwObject

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <RequestPaysDelagate> delegate;

// input parameters:
@property (nonatomic, readwrite, copy) NSString* userId;
@property (nonatomic, readwrite, copy) NSString* userSession;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@end
