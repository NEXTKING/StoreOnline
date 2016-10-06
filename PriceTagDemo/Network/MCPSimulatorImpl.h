//
//  MCPSimulatorImpl.h
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProtocol.h"

@class GetImageParamsContainer;

@interface MCPSimulatorImpl : NSObject
    <MCProtocol>

@property (nonatomic, copy, readwrite) NSString *accessToken;
@property (nonatomic, copy, readwrite) NSString *userId;
@property (nonatomic, copy, readwrite) NSString *registerSessionId;

@property (nonatomic, assign, readwrite) int lastResult;

- (void) enableNetworkActivityIndicator:(BOOL)enable;
- (void) generateData;
- (void) hello:(id<HelloDelegate>) delegate;


@end
