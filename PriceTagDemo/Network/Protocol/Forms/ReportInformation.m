//
//  ReportInformation.m
//  Checklines
//
//  Created by Denis Kurochkin on 03.11.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "ReportInformation.h"

@implementation ReportInformation

@synthesize formId = _formId;
@synthesize title = _title;
@synthesize explanatoryImagePath = _explanatoryImagePath;

- (void) dealloc
{
    [_formId release];
    [_title release];
    [_answer release];
    [_explanatoryImagePath release];
    
    [super dealloc];
}

- (void) clearAnswers
{
    self.answer = nil;
}

@end
