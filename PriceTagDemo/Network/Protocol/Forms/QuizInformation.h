//
//  QuizInformation.h
//  Checklines
//
//  Created by Denis Kurochkin on 03.11.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "BlankInformation.h"

@interface QuestionInformation : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, retain) NSArray *answers;
@property (nonatomic, copy) NSString *chosenAnswer;
@end

@interface QuizInformation : BlankInformation

@property (nonatomic, retain) NSArray* questions;

- (BOOL) isReady;
- (NSString*) generateJSON;


@end
