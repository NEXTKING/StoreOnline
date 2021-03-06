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
    NSInteger _excessItemsCount;
    NSInteger _printedCount;
    NSDate *_startDate;
    NSDate *_endDate;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *excessLabel;

@end

@implementation TaskProgressOverlayController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initializeTimer
{
    if (_timer == nil)
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTickAction) userInfo:nil repeats:YES];
}

- (void)destroyTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)timerTickAction
{
    [self updateTimeLabel];
    [self updateSpeedLabel];
}

- (void)dealloc
{
    [self destroyTimer];
}

#pragma mark Public setters

- (void)setTitleText:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate totalItemsCount:(NSInteger)totalCount completeItemsCount:(NSInteger)completeCount excessItemsCount:(NSInteger)excessCount totalPrintedCount:(NSInteger)printedCount timerIsRunning:(BOOL)timerIsRunning
{
    _titleLabel.text = title;
    _startDate = startDate;
    _endDate = endDate;
    _totalItemsCount = totalCount;
    _completeItemsCount = completeCount;
    _excessItemsCount = excessCount;
    _printedCount = printedCount;
    
    [self updateProgressBar];
    [self updateProgressLabel];
    [self updateTimeLabel];
    [self updateSpeedLabel];
    [self updateExcessLabel];
    timerIsRunning ? [self initializeTimer] : [self destroyTimer];
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
    self.progressLabel.text = [NSString stringWithFormat:@"Завершено %ld из %ld", _completeItemsCount, _totalItemsCount];
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
        NSDate *endDate = _endDate != nil ? _endDate : [NSDate date];
        NSTimeInterval secondsPassed = [endDate timeIntervalSinceDate:_startDate];
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
        NSDate *endDate = _endDate != nil ? _endDate : [NSDate date];
        NSTimeInterval secondsPassed = [endDate timeIntervalSinceDate:_startDate];
        
        if ((secondsPassed / (60 * 60 * 24)) > 1)
        {
            CGFloat average = (_completeItemsCount + _excessItemsCount) / (secondsPassed / (60 * 60 * 24));
            self.speedLabel.text = [NSString stringWithFormat:@"%.f / день", average];
        }
        else if ((secondsPassed / (60 * 60)) > 1)
        {
            CGFloat average = (_completeItemsCount + _excessItemsCount) / (secondsPassed / (60 * 60));
            self.speedLabel.text = [NSString stringWithFormat:@"%.02f / час", average];
        }
        else if ((secondsPassed / 60) > 1)
        {
            CGFloat average = (_completeItemsCount + _excessItemsCount) / (secondsPassed / 60);
            self.speedLabel.text = [NSString stringWithFormat:@"%.02f / мин", average];
        }
        else
        {
            self.speedLabel.text = [NSString stringWithFormat:@"%ld / мин", (_completeItemsCount + _excessItemsCount)];
        }
    }
    else
        self.speedLabel.text = @"";
}

- (void)updateExcessLabel
{
    NSMutableString *excessLabelText = [[NSMutableString alloc] initWithString: (_excessItemsCount > 0 ? [NSString stringWithFormat:@"Излишки по ЗнП %ld", _excessItemsCount] : @"Излишек по ЗнП нет")];
    [excessLabelText appendString:(_printedCount > 0 ? [NSString stringWithFormat:@", всего расп. %ld", _printedCount] : @"")];
    _excessLabel.text = excessLabelText;
}

@end
