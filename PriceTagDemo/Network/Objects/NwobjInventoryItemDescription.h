//
//  NwobjInventoryItemDescription.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 04.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjInventoryItemDescription : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <ItemDescriptionDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* barcode;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
