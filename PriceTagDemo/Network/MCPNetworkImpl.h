//
//  MCPNetworkImpl.h
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProtocol.h"

@interface MCPNetworkImpl : NSObject
    <MCProtocol>

@property (copy, readwrite) NSString *accessToken;
@property (copy, readwrite) NSString *userId;
@property (nonatomic, copy, readwrite) NSString *registerSessionId;
@property (nonatomic, assign, readwrite) int lastResult;
@property (nonatomic, copy) NSString* serverAddress;

- (void) hello:(id<HelloDelegate>) delegate;

@end
