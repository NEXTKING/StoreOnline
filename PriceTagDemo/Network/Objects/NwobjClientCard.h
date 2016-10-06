//
//  NwobjClientCard.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 27.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjClientCard : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <ClientCardDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* cardNumber;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
