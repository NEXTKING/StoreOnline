//
//  SynchronizationController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncronizationDelegate <NSObject>

- (void) syncProgressChanged:(double)progress;
- (void) syncCompleteWithResult:(int) result;
- (void) resetPortionsCompleteWithResult:(int)result;

@end

@interface SynchronizationController : NSObject

@property (nonatomic, weak) id<SyncronizationDelegate> delegate;
@property (nonatomic, readonly) BOOL syncIsRunning;
@property (nonatomic, readonly) double syncProgress;

+ (instancetype)sharedInstance;
- (void) synchronize;
- (void) resetPortions;

@end
