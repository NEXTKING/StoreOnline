//
//  ClaimItem.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ClaimItem.h"

@interface ClaimItem ()
@property (nonatomic, strong) NSNumber *claimID;
@property (nonatomic, strong) NSString *claimNumber;
@property (nonatomic, strong) NSDate *incomingDate;
//@property (nonatomic, strong) NSDate *startDate;
//@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSNumber *userID;
@end

@implementation ClaimItem

- (instancetype)initWithClaimID:(NSNumber *)claimID claimNumber:(NSString *)claimNumber incomingDate:(NSDate *)incomingDate startDate:(NSDate *)startDate endDate:(NSDate *)endDate userID:(NSNumber *)userID
{
    self = [super init];
    if (self)
    {
        _claimID = claimID;
        _claimNumber = claimNumber;
        _incomingDate = incomingDate;
        _startDate = startDate;
        _endDate = endDate;
        _userID = userID;
    }
    return self;
}

- (NSUInteger)totalCount
{
    return 0;
}

- (NSUInteger)scannedCount
{
    return 0;
}

- (NSString *)barcode
{
    return nil;
}

- (NSString *)descriptionForKey:(NSString *)key
{
    NSArray *descriptions = @[@"claimNumber", @"statusDescription", @"remainTimeDescription", @"incomingDateDescription"];
    
    if ([descriptions containsObject:key])
    {
        return [self performSelector:NSSelectorFromString(key)];
    }
    else
        return nil;
}

- (void)setScannedCount:(NSUInteger)scannedCount
{
    
}

- (void)setCancelReason:(NSString *)cancelReason
{
    
}

#pragma mark descriptions

- (NSString *)claimNumber
{
    return _claimNumber;
}

- (NSString *)statusDescription
{
    if (_startDate == nil)
        return @"Новое";
    else if (_endDate == nil)
        return @"Не завершено";
    else
        return @"Выполнено";
}

- (NSString *)remainTimeDescription
{
    if (_startDate == nil || _endDate == nil)
    {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_incomingDate];
        if (timeInterval > 0)
        {
            NSInteger minutes = 30 - (timeInterval / 60);
            if (minutes > 0)
                return [NSString stringWithFormat:@"Времени осталось: %ld мин.", minutes];
        }
        return @"Времени осталось: 0 мин.";
    }
    else
    {
        NSTimeInterval duration = [_endDate timeIntervalSinceDate:_startDate];
        
        NSInteger hours = floor(duration/(60*60));
        NSInteger minutes = floor((duration/60) - hours * 60);
        NSInteger seconds = floor(duration - (minutes * 60) - (hours * 60 * 60));
        
        return [NSString stringWithFormat:@"Время обработки: %02ld:%02ld:%02ld", hours, minutes, seconds];
    }
}

- (NSString *)incomingDateDescription
{
    if (_incomingDate)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd.MM.yyyy hh:mm:ss";
        return [NSString stringWithFormat:@"Момент поступления: %@", [dateFormatter stringFromDate:_incomingDate]];
    }
    else
        return @"Момент поступления неизвестен";
}

@end
