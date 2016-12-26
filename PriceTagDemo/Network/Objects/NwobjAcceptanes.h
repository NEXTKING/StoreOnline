//
//  NwobjAcceptanes.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 17/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjAcceptanes : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <AcceptanesDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* shopId;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@property (copy, nonatomic) void (^completionHandler) (NSArray<AcceptanesInformation*>*);

@end
