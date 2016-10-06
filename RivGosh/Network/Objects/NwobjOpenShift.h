//
//  NwobjOpenShift.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 06.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol+RivGosh.h"

@interface NwobjOpenShift : NwObject

@property (nonatomic, weak) id <PrinterDelegate> delegate;
@property (nonatomic, copy) NSDate* date;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
