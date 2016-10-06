//
//  NwobjSendCart.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 28.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjSendCart : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <SendCartDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSDictionary* cartData;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@end





@interface NwobjEndOfInvent : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <SendCartDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* shopId;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;


@end
