//
//  TasksNavigationController.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskProgressOverlayController.h"


#define OSTIN_TASK_OVERLAY_HEIGHT 96
#define OSTIN_TASK_OVERLAY_ANIMATION_DURATION 0.2

@interface TasksNavigationController : UINavigationController
@property (readonly) TaskProgressOverlayController *overlayController;
@end
