//
//  AppSuspendingBlocker.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 16/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSuspendingBlocker : NSObject

- (void)startBlock;
- (void)stopBlock;

@end
