//
//  NwobjTaskInformation.m
//  Checklines
//
//  Created by Kurochkin on 29/10/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwobjTaskInformation.h"
#import "Logger.h"
#import "SBJson.h"
#import "TaskInformation.h"

//forms
#import "PhotoInformation.h"
#import "QuizInformation.h"
#import "ReportInformation.h"

@implementation NwobjTaskInformation

- (void) dealloc
{
    [_taskInfo release];
    [_delegate release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _succeeded = NO;
        _resultCode = -1;
        _delegate = nil;
        _taskInfo = [TaskInformation new];
    }
    return self;
}

- (void) setDelegate:(id<TaskInfoDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(TaskInfoDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        if (_delegate)
            [_delegate release];
        
        _delegate = [delegate retain];
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (void) run: (NSString*) url
{
    // Check input parameters:
    /*if ( _userId == Nil )
    {
        [Logger log:self method:@"run" format:@"'userId' property is not set"];
        [self complete:NO];
        return;
    }*/
    if ( _userSession == Nil )
    {
        [Logger log:self method:@"run" format:@"'userSession' property is not set"];
        [self complete:NO];
        return;
    }
    
    if ( _taskId == nil)
    {
        [Logger log:self method:@"run" format:@"'taskID' property is not set"];
        [self complete:NO];
        return;
    }
    
    
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/mobile/task/points/", url];
    nwReq.httpMethod = _http_method;
    //[nwReq addParam:@"userId" withValue:_userId];
    [nwReq addParam:@"token" withValue:_userSession];
    [nwReq addParam:@"tid" withValue:_taskId];
    
    NSURLRequest *__exec_request = [nwReq buildURLRequest];
    
    assert(__exec_request != nil);
    
    _exec_connection = [[NSURLConnection alloc] initWithRequest:__exec_request delegate:self];
    
    assert(_exec_connection != nil);
    
    [super run:Nil];    // enable network activity indicator
}

- (void) complete: (BOOL) isSuccessfull
{
    [super complete:isSuccessfull];     // disable network activity indicator
    
    _succeeded = isSuccessfull;
    
    _resultCode = -1;
    if ( _succeeded )
    {   // Request successfully performed
        NSString *dataString = [[NSString alloc] initWithData:_exec_data encoding:NSUTF8StringEncoding];
        [Logger log:self method:Nil format:@"TextRepres.: %@", dataString];
        
        // Process results
        // Handle Cookies
        
        /*if ( _cookies )
         {
         if ( [_cookies objectForKey:@"JSESSIONID"] != Nil )
         {
         if ( _accessToken )
         [_accessToken release];
         _accessToken = [[_cookies objectForKey:@"JSESSIONID"] copy];
         [Logger log:self method:@"complete" format:@"JSESSIONID=%@", _accessToken];
         }
         else
         {
         _resultCode = -1;
         [Logger log:self method:@"complete" format:@"'JSESSIONID' is not found"];
         }
         } */
        
        // Parse JSON
        NSDictionary *result = [dataString JSONValue];
        if ( result )
        {
            if ( [result objectForKey:@"error_code"] != Nil )
            {
                _resultCode = [[result valueForKey:@"error_code"] intValue];
                [Logger log:self method:@"complete" format:@"result=%d", _resultCode];
            }
            else
            {
                _resultCode = -1;
                [Logger log:self method:@"complete" format:@"'result' is not found"];
            }
        }
        else
            _resultCode = -2;
        
        id obj = nil;
        
        if ( _resultCode == 0 )
        {
            //NSDictionary *taskInfoDict = nil;
            //if ([result objectForKey:@"task"])
            //{
                /*taskInfoDict = [result objectForKey:@"task"];
                
                obj = [taskInfoDict objectForKey:@"id"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    _taskInfo.taskId = obj;
                obj = [taskInfoDict objectForKey:@"finishDateTime"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    [_taskInfo setFinishDateFromString:obj];
                obj = [taskInfoDict objectForKey:@"startDateTime"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    [_taskInfo setStartDateFromString:obj]; */
        
                NSArray *blanksArray = nil;
                obj = [result objectForKey:@"points"];
                if (obj && [obj isKindOfClass:[NSArray class]])
                    blanksArray = obj;
                
                NSDictionary *currentForm = nil;
                
                NSMutableArray *blanks = [NSMutableArray new];
                NSMutableArray *reports = [[NSMutableArray alloc] init];
                NSMutableArray *quizes = [[NSMutableArray alloc] init];
                NSMutableArray *photos = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < blanksArray.count; ++ i)
                {
                    currentForm = blanksArray[i];
                    BlankInformation *blankInfo = nil;
                    
                    NSInteger formType = -1;
                    obj = [currentForm objectForKey:@"type"];
                    if (obj && [obj isKindOfClass:[NSString class]])
                        formType = [obj intValue];
                    
                    switch (formType) {
                        case 1:
                        {
                            ReportInformation *reportInfo = [ReportInformation new];
                            blankInfo = reportInfo;
                            
                            obj = [currentForm objectForKey:@"content"];
                            if (obj && [obj isKindOfClass:[NSString class]])
                                reportInfo.title = obj;
                            obj = [currentForm objectForKey:@"id"];
                            if (obj && [obj isKindOfClass:[NSNumber class]])
                                reportInfo.formId = [NSString stringWithFormat:@"%ld",(long)[obj integerValue]];;
                            obj = [currentForm objectForKey:@"expl_image"];
                            if (obj && [obj isKindOfClass:[NSString class]])
                                 reportInfo.explanatoryImagePath = obj;
                            [reports addObject:reportInfo];
                            [reportInfo release];
                        }
                            
                            break;
                        case 2:
                        {
                            QuizInformation *quizInfo = [QuizInformation new];
                            blankInfo = quizInfo;
                            
                            obj = [currentForm objectForKey:@"id"];
                            if (obj && [obj isKindOfClass:[NSNumber class]])
                                quizInfo.formId = [NSString stringWithFormat:@"%ld",(long)[obj integerValue]];
                            obj = [currentForm objectForKey:@"content"];
                            if (obj && [obj isKindOfClass:[NSArray class]])
                                [self parseQuiz:obj withObject:quizInfo];
                            obj = [currentForm objectForKey:@"expl_image"];
                            if (obj && [obj isKindOfClass:[NSString class]])
                                quizInfo.explanatoryImagePath = obj;
                            
                            [quizes addObject:quizInfo];
                            [quizInfo release];
                        }
                            break;
                        case 3:
                        {
                            PhotoInformation *photoInfo = [PhotoInformation new];
                            blankInfo = photoInfo;
                            
                            obj = [currentForm objectForKey:@"content"];
                            if (obj && [obj isKindOfClass:[NSString class]])
                                photoInfo.title = obj;
                            obj = [currentForm objectForKey:@"id"];
                            if (obj && [obj isKindOfClass:[NSNumber class]])
                                photoInfo.formId = [NSString stringWithFormat:@"%ld",(long)[obj integerValue]];
                            obj = [currentForm objectForKey:@"expl_image"];
                            if (obj && [obj isKindOfClass:[NSString class]])
                                photoInfo.explanatoryImagePath = obj;
                            [photos addObject:photoInfo];
                            [photoInfo release];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    [blanks addObject:blankInfo];
                    
                }
                
                _taskInfo.photos = photos;
                _taskInfo.reports = reports;
                _taskInfo.quizes = quizes;
                _taskInfo.blanks = blanks;
                [blanks release];
                [photos release];
                [reports release];
                [quizes release];
                    
        }

            /*
             else
             {
             _resultCode = -1;
             [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
             }yyyy-MM-dd HH:mm:ss             */
        //}
        
        [dataString release];
    }
    
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
        [_delegate taskInfoCompleted:_resultCode taskInformation:_taskInfo];
}

- (void) parseQuiz:(NSArray*)content withObject:(QuizInformation*)quiz
{
    id obj;
    
    //NSDictionary *quizDict;
    //NSArray *questionsArray;
    
    /*obj = [content objectForKey:@"quiz"];
    if (obj && [obj isKindOfClass:[NSDictionary class]])
        quizDict = obj;
    else
        return;
    
    obj = [quizDict objectForKey:@"title"];
    if (obj && [obj isKindOfClass:[NSString class]])
        quiz.title = obj;
    obj = [quizDict objectForKey:@"questions"];
    if (obj && [obj isKindOfClass:[NSArray class]])
        questionsArray = obj; */
    if (content.count < 1)
        return;
    
    NSEnumerator *questionsEnumerator = [content objectEnumerator];
    NSDictionary *currentQuestionDict = nil;
    NSMutableArray *questionObjects = [[NSMutableArray alloc] init];
    
    while (currentQuestionDict = [questionsEnumerator nextObject])
    {
        QuestionInformation *questionInfo = [QuestionInformation new];
        obj = [currentQuestionDict objectForKey:@"question"];
        if (obj && [obj isKindOfClass:[NSString class]])
            questionInfo.title = obj;
        obj = [currentQuestionDict objectForKey:@"answers"];
        if (obj && [obj isKindOfClass:[NSArray class]])
            questionInfo.answers = obj;
        
        [questionObjects addObject:questionInfo];
        [questionInfo release];
    }
    
    quiz.questions = questionObjects;
    [questionObjects release];
    
    
}


@end
