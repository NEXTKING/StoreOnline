//
//  DPSyncButton.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "DPSyncButton.h"

@interface DPSyncButton()
@property (nonatomic, assign) BOOL animationIsRunning;
@property (nonatomic, copy) NSString *originalTitle;
@property (nonatomic, assign) NSUInteger numberOfDots;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation DPSyncButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopAnimation];
}

- (void)startAnimation
{
    if (![self animationIsRunning])
    {
        _originalTitle = self.titleLabel.text;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLabel) userInfo:nil repeats:YES];
        [self rotateImageView];
        _animationIsRunning = YES;
    }
}

- (void)stopAnimation
{
    if ([self animationIsRunning])
    {
        [self removeAnimation];
        _animationIsRunning = NO;
    }
}

- (void)restoreAnimation
{
    if ([self animationIsRunning])
    {
        [self removeAnimation];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLabel) userInfo:nil repeats:YES];
        [self rotateImageView];
    }
}

- (void)removeAnimation
{
    [self.imageView.layer removeAnimationForKey:@"SpinAnimation"];
    [_timer invalidate];
    [self setTitle:_originalTitle forState:UIControlStateNormal];
    _numberOfDots = 0;
}

- (void)rotateImageView
{
    if ([self.imageView.layer animationForKey:@"SpinAnimation"] == nil)
    {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 1.5f;
        animation.repeatCount = INFINITY;
        [self.imageView.layer addAnimation:animation forKey:@"SpinAnimation"];
    }
}

- (void)changeLabel
{
    switch (_numberOfDots)
    {
        case 0:
            [self setTitle:[NSString stringWithFormat:@"%@.", _originalTitle] forState:UIControlStateNormal];
            _numberOfDots = 1;
            break;
        case 1:
            [self setTitle:[NSString stringWithFormat:@"%@..", _originalTitle] forState:UIControlStateNormal];
            _numberOfDots = 2;
            break;
        case 2:
            [self setTitle:[NSString stringWithFormat:@"%@...", _originalTitle] forState:UIControlStateNormal];
            _numberOfDots = 3;
            break;
        default:
            [self setTitle:_originalTitle forState:UIControlStateNormal];
            _numberOfDots = 0;
            break;
    }
}

@end
