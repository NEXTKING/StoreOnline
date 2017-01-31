//
//  TransitionDelegate.m
//  PartitionTest
//
//  Created by Denis Kurochkin on 27/01/2017.
//  Copyright © 2017 Denis Kurochkin. All rights reserved.
//

#import "TransitionDelegate.h"
#import "PresentingAnimator.h"

@implementation TransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    PresentingAnimator* animator = [PresentingAnimator new];
    animator.isPresenting = YES;
    animator.initialFrame = _initialFrame;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed
{
    PresentingAnimator* animator = [PresentingAnimator new];
    animator.isPresenting = NO;
    animator.initialFrame = _initialFrame;
    return  animator;
}

@end
