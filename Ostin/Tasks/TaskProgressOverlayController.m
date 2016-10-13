//
//  TaskProgressOverlayController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "TaskProgressOverlayController.h"

@interface TaskProgressOverlayController ()
{
    NSInteger _completeItemsCount;
    NSInteger _totalItemsCount;
    NSDate *_startDate;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@end

@implementation TaskProgressOverlayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTickAction) userInfo:nil repeats:YES];
}

- (void)timerTickAction
{
    [self updateTimeLabel];
    [self updateSpeedLabel];
}

- (void)dealloc
{
    if (_timer != nil && [_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark Public setters

- (void)setTitleText:(NSString *)title startDate:(NSDate *)startDate totalItemsCount:(NSInteger)totalCount completeItemsCount:(NSInteger)completeCount
{
    _titleLabel.text = title;
    _startDate = startDate;
    _totalItemsCount = totalCount;
    _completeItemsCount = completeCount;
    
    [self updateProgressBar];
    [self updateProgressLabel];
    [self updateTimeLabel];
    [self updateSpeedLabel];
}

- (void)setCompleteItemsCount:(NSInteger)count
{
    if (_completeItemsCount != count)
    {
        _completeItemsCount = count;
        [self updateProgressBar];
        [self updateProgressLabel];
        [self updateSpeedLabel];
    }
}

#pragma mark UI update methods

- (void)updateProgressLabel
{
    self.progressLabel.text = [NSString stringWithFormat:@"Завершено %d из %d", _completeItemsCount, _totalItemsCount];
}

- (void)updateProgressBar
{
    if (_totalItemsCount > 0)
    {
        CGFloat totalWidth = self.view.bounds.size.width;
        CGFloat progressPercent = _completeItemsCount * 100 / _totalItemsCount;
        CGFloat progressWidth = totalWidth * progressPercent / 100;
        
        self.progressWidthConstraint.constant = progressWidth;
    }
    else
        self.progressWidthConstraint.constant = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateTimeLabel
{
    if (_startDate != nil)
    {
        NSTimeInterval secondsPassed = [[NSDate date] timeIntervalSinceDate:_startDate];
        NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
        dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
        dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
        
        self.timeLabel.text = [dateComponentsFormatter stringFromTimeInterval:secondsPassed];
    }
    else
        self.timeLabel.text = @"00:00:00";
}

- (void)updateSpeedLabel
{
    if ((_completeItemsCount > 0) && (_startDate != nil))
    {
        NSTimeInterval secondsPassed = [[NSDate date] timeIntervalSinceDate:_startDate];
        
        if ((secondsPassed / (60 * 60 * 24)) > 1)
        {
            CGFloat average = _completeItemsCount / (secondsPassed / (60 * 60 * 24));
            self.speedLabel.text = [NSString stringWithFormat:@"%.f / день", average];
        }
        else if ((secondsPassed / (60 * 60)) > 1)
        {
            CGFloat average = _completeItemsCount / (secondsPassed / (60 * 60));
            self.speedLabel.text = [NSString stringWithFormat:@"%.02f / час", average];
        }
        else if ((secondsPassed / 60) > 1)
        {
            CGFloat average = _completeItemsCount / (secondsPassed / 60);
            self.speedLabel.text = [NSString stringWithFormat:@"%.02f / мин", average];
        }
        else
        {
            self.speedLabel.text = [NSString stringWithFormat:@"%d / мин", _completeItemsCount];
        }
    }
    else
        self.speedLabel.text = @"";
}

@end