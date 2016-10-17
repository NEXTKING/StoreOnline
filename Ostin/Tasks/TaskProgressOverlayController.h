//
//  TaskProgressOverlayController.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskProgressOverlayController : UIViewController

- (void)setTitleText:(NSString *)title startDate:(NSDate *)startDate totalItemsCount:(NSInteger)totalCount completeItemsCount:(NSInteger)completeCount timerIsRunning:(BOOL)timerIsRunning;
- (void)setCompleteItemsCount:(NSInteger)count;

@end
