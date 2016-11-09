//
//  NwobjPrintText.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 02/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCPNetworkImpl+RivGosh.h"

@interface NwobjPrintText : NwObject

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, weak) id <PrinterDelegate> delegate;

// input parameters:

@property (nonatomic, strong) NSArray* operationsHistory;
@property (nonatomic, strong) id reqID;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;


@end
