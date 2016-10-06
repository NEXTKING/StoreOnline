//
//  NwobjStock.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 30/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

typedef void (^SaveCompletion) (NSArray<ItemInformation*>*);

@interface NwobjStock : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <StockDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* barcode;
@property (nonatomic, copy) NSString* shopId;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@property (copy, nonatomic) SaveCompletion completionHandler;

@end
