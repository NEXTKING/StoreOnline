//
//  TasksNavigationController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "TasksNavigationController.h"
#import "TasksViewController.h"
#import "ItemsListViewController.h"
#import "OstinViewController.h"

@interface UIView (childViews)
- (NSArray*)allSubviews;
@end

@implementation UIView (childViews)
- (NSArray*)allSubviews
{
    __block NSArray* allSubviews = [NSArray arrayWithObject:self];
    
    [self.subviews enumerateObjectsUsingBlock:^( UIView* view, NSUInteger idx, BOOL*stop) {
        allSubviews = [allSubviews arrayByAddingObjectsFromArray:[view allSubviews]];
    }];
    return allSubviews;
}
@end

@interface TasksNavigationController () <UINavigationControllerDelegate>
@property (strong, nonatomic) TaskProgressOverlayController *overlayController;
@property (strong, nonatomic) NSMutableDictionary *scrollViewInsets;
@end

@implementation TasksNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    _scrollViewInsets = [[NSMutableDictionary alloc] initWithCapacity:3];
}

- (TaskProgressOverlayController *)overlayController
{
    if (_overlayController == nil)
        [self initializeOverlayController];
    
    return _overlayController;
}

- (void)initializeOverlayController
{
    _overlayController = [[TaskProgressOverlayController alloc] initWithNibName:@"TaskProgressOverlayController" bundle:nil];
    _overlayController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _overlayController.view.alpha = 0.0;
    [self.view addSubview:_overlayController.view];
}

- (void)showOverlayController
{
    if (self.overlayController != nil)
    {
        UIViewController *topViewController = [self topViewController];
        CGFloat yOffset = topViewController.topLayoutGuide.length;
        CGFloat width = topViewController.view.bounds.size.width;
        CGFloat height = OSTIN_TASK_OVERLAY_HEIGHT;
        CGRect overlayFrame = CGRectMake(0, yOffset, width, height);
        
        self.overlayController.view.frame = overlayFrame;
        [UIView animateWithDuration:OSTIN_TASK_OVERLAY_ANIMATION_DURATION animations:^{
            self.overlayController.view.alpha = 1.0;
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)hideOverlayController
{
    if (self.overlayController != nil)
    {
        [UIView animateWithDuration:OSTIN_TASK_OVERLAY_ANIMATION_DURATION animations:^{
            self.overlayController.view.alpha = 0.0;
        } completion:^(BOOL finished) {

        }];
    }
}

- (void)increaseTopScrollViewInsetInViewController:(UIViewController *)viewController
{
    NSArray *subviews = [viewController.view allSubviews];
    
    for (UIView *subview in subviews)
    {
        if ([subview isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = (UIScrollView *)subview;
            NSString *memory = [NSString stringWithFormat:@"%p", scrollView];
            
            // to avoid creating extra space after we return to screen from other tabs, pop vc, etc.
            if (![_scrollViewInsets valueForKey:memory])
            {
                [_scrollViewInsets setValue:[NSNumber numberWithFloat:scrollView.contentInset.top] forKey:memory];
            
                CGFloat top = scrollView.contentInset.top;
                UIEdgeInsets defaultInset = scrollView.contentInset;
                scrollView.contentInset = UIEdgeInsetsMake(top + OSTIN_TASK_OVERLAY_HEIGHT, defaultInset.left, defaultInset.bottom, defaultInset.right);
                scrollView.contentOffset = CGPointMake(0, -(top + OSTIN_TASK_OVERLAY_HEIGHT));

            }
            return;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isMemberOfClass:[ItemsListViewController class]])
    {
        [self increaseTopScrollViewInsetInViewController:viewController];
    }
    else if ([viewController isMemberOfClass:[OstinViewController class]])
    {
        [self increaseTopScrollViewInsetInViewController:viewController];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isMemberOfClass:[TasksViewController class]])
    {
        [self.scrollViewInsets removeAllObjects];
        [self hideOverlayController];
    }
    else if ([viewController isMemberOfClass:[ItemsListViewController class]])
    {
        [self showOverlayController];
    }
}

@end
