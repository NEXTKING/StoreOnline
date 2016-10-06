//
//  NwobjRestartPrintQueue.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 31.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol+RivGosh.h"

@interface NwobjRestartPrintQueue : NwObject


@property (nonatomic, weak) id <PrinterDelegate> delegate;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
