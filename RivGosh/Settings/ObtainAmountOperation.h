//
//  ObtainAmountOperation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 14/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCPServer.h"

@interface ObtainAmountOperation : NSOperation

@property (nonatomic, assign) double terminalAmount;

@property (nonatomic, assign, readonly) BOOL success;
@property (nonatomic, strong, readonly) NSError* error;
@property (nonatomic, strong, readonly) ZReport* zReport;
@property (nonatomic, copy, readonly) NSNumber* bankAmount;

@end
