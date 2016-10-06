//
//  SynchronizationController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncronizationDelegate <NSObject>

- (void) syncCompleteWithResult:(int) result;

@end

@interface SynchronizationController : NSObject

@property (nonatomic, weak) id<SyncronizationDelegate> delegate;

- (void) synchronize;

@end
