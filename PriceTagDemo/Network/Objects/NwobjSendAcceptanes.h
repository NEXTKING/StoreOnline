//
//  NwobjSendAcceptanes.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 22/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjSendAcceptanes : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <AcceptanesDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* shopId;
@property (nonatomic, copy) NSDictionary* acceptanesData;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@end
