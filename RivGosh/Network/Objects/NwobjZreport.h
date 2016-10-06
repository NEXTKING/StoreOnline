//
//  NwobjZreport.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCPNetworkImpl+RivGosh.h"

@interface NwobjZreport : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <PrinterDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* receiptID;
@property (nonatomic, copy) NSNumber* amount;
@property (nonatomic, strong) id reqID;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
