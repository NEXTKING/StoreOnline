//
//  NwobjPaymentsHistory.h
//  Checklines
//
//  Created by Denis Kurochkin on 12/17/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjPaymentsHistory : NwObject

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <PaymentsHistoryDelegate> delegate;

// input parameters:
@property (nonatomic, readwrite, copy) NSString* userId;
@property (nonatomic, readwrite, copy) NSString* userSession;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@end
