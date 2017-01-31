//
//  PresentingAnimator.h
//  PartitionTest
//
//  Created by Denis Kurochkin on 27/01/2017.
//  Copyright © 2017 Denis Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentingAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) CGRect initialFrame;

@end
