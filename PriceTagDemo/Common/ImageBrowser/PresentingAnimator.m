//
//  PresentingAnimator.m
//  PartitionTest
//
//  Created by Denis Kurochkin on 27/01/2017.
//  Copyright © 2017 Denis Kurochkin. All rights reserved.
//

#import "PresentingAnimator.h"
#import "ImageViewController.h"

@implementation PresentingAnimator
{
}


- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_isPresenting)
        [self presentationAnimation:transitionContext];
    else
        [self dismissimgAnimation:transitionContext];
}


- (void) presentationAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!toVC)
        return;
    
    UIView* snapshot = [toVC.view snapshotViewAfterScreenUpdates:YES];
    UIView* blackCover = [[UIView alloc] initWithFrame:fromVC.view.frame];
    blackCover.backgroundColor = [UIColor blackColor];
    blackCover.alpha = 0.0;
    
    
    snapshot.frame = _initialFrame;
    snapshot.layer.masksToBounds = YES;
    
    [containerView insertSubview:blackCover aboveSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshot];
    toVC.view.hidden = YES;
    
    //toVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView animateWithDuration:
     0.5
                          delay:0.0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:0
                     animations:^{
                         blackCover.alpha = 1.0;
                         snapshot.frame = fromVC.view.frame;
                         fromVC.view.layer.backgroundColor = [UIColor blackColor].CGColor;
                     } completion:^(BOOL finished) {
                         
                         [blackCover removeFromSuperview];
                         toVC.view.hidden = NO;
                         [snapshot removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

- (void) dismissimgAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    ImageViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!toVC)
        return;
    
    UIView* snapshot = [fromVC.view snapshotViewAfterScreenUpdates:YES];
    //snapshot.frame = CGRectMake(0, 0, 10, 10);
    snapshot.layer.masksToBounds = YES;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshot];
    fromVC.view.hidden = YES;
    
    CGRect finalRect = _initialFrame;
    finalRect.size.width = _initialFrame.size.width/2;
    finalRect.size.height = _initialFrame.size.height/2;
    finalRect.origin.x += (_initialFrame.size.width-finalRect.size.width)/2;
    finalRect.origin.y += (_initialFrame.size.height-finalRect.size.height)/2;
    
    //toVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView animateWithDuration:
     0.5
                          delay:0.0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:0
                     animations:^{
                         snapshot.frame = finalRect;
                         snapshot.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         //toVC.view.transform = CGAffineTransformIdentity;
                         //toVC.view.frame = _imageView.frame;
                         
                         fromVC.view.hidden = NO;
                         [snapshot removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

@end
