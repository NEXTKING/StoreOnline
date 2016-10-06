//
//  TaskInformation.m
//  Checklines
//
//  Created by Denis Kurochkin on 19.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "TaskInformation.h"
#import "BlankInformation.h"

@implementation TaskInformation

- (void) dealloc
{
    [_taskId release];
    [_clientName release];
    [_taskName release];
    [_address release];
    [_finishDateTime release];
    [_startDateTime release];
    [_takeDateTime release];
    [_endDateTime release];
    [_checkDateTime release];
    [_blanks release];
    [_taskDescription release];
    [_taskInworkId release];
    [_comment release];
    [super dealloc];
    
}

- (void) setStartDateFromString:(NSString *)startDate
{
    [_startDateTime release];
    
    _startDateTime = [[self dateFromString:startDate format:@"yyyy-MM-dd HH:mm:ss"] retain];
}

- (void) setFinishDateFromString:(NSString *)finishDate
{
    [_finishDateTime release];
    
    _finishDateTime = [[self dateFromString:finishDate format:@"yyyy-MM-dd HH:mm:ss"] retain];
    
}

- (void) setTakeDateFromString:(NSString *)takeDate
{
    [_takeDateTime release];
    
    _takeDateTime = [[self dateFromString:takeDate format:@"yyyy-MM-dd HHZ"] retain];
    
}

- (void) setEndDateFromString:(NSString *)endDate
{
    [_endDateTime release];
    _endDateTime = [[self dateFromString:endDate format:@"yyyy-MM-dd HHZ"] retain];
}

- (void) setCheckDateFromString:(NSString *)checkDate
{
    [_checkDateTime release];
    _checkDateTime = [[self dateFromString:checkDate format:@"yyyy-MM-dd HHZ"] retain];
}

- (NSDate*) dateFromString:(NSString*)stringDate format:(NSString*) format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"] autorelease]];
    
    [dateFormatter setDateFormat:format];
    NSDate* dateToReturn = [dateFormatter dateFromString:stringDate];
    [dateFormatter release];
    
    return dateToReturn;
}

- (void) clearAnswers
{
    for (int i = 0; i<_blanks.count; ++i) {
        BlankInformation *blank = _blanks[i];
        [blank clearAnswers];
    }
}

@end
