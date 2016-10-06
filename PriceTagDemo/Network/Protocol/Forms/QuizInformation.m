//
//  QuizInformation.m
//  Checklines
//
//  Created by Denis Kurochkin on 03.11.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "QuizInformation.h"

@implementation QuestionInformation


- (void) dealloc
{
    [_chosenAnswer release];
    [_answers release];
    [_title release];
    
    [super dealloc];
}

@end

@implementation QuizInformation

@synthesize formId = _formId;
@synthesize title = _title;
@synthesize explanatoryImagePath = _explanatoryImagePath;

- (BOOL) isReady
{
    BOOL ready = YES;
    for (QuestionInformation* questionInfo in _questions)
    {
        if (!questionInfo.chosenAnswer)
            ready = NO;
    }
    
    return ready;
}



- (NSString*) generateJSON
{
    NSMutableString *resultString = [[[NSMutableString alloc] init] autorelease];
    if (!_questions || _questions.count == 0)
        return nil;
    //[resultString appendString:@"{\\\"quiz\\\":{"];
    //[resultString appendFormat:@"\\\"title\\\":\\\"%@\\\",", _title];
    [resultString appendString:@"["];
    
    for (int i = 0; i < _questions.count; ++ i)
    {
        QuestionInformation *questionInfo = [_questions objectAtIndex:i];
        [resultString appendFormat:@"{\"question\":\"%@\",", questionInfo.title];
        [resultString appendFormat:@"\"answer\":\"%@\"}", questionInfo.chosenAnswer];
        
        if (i != _questions.count-1)
            [resultString appendFormat:@","];
        
    }
    
    [resultString appendString:@"]"];
    
    return resultString;
}

- (void) clearAnswers
{
    for (int i = 0; i < _questions.count; ++ i)
    {
        QuestionInformation *questionInfo = [_questions objectAtIndex:i];
        questionInfo.chosenAnswer = nil;
    }
}

- (void) dealloc
{
    [_formId release];
    [_title release];
    [_questions release];
    [_explanatoryImagePath release];
    
    [super dealloc];
}

@end
