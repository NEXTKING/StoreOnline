//
//  NwobjTasks.m
//  Checklines
//
//  Created by Denis Kurochkin on 19.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwobjTasks.h"
#import "Logger.h"
#import "SBJson.h"
#import "TaskInformation.h"

@implementation NwobjTasks

- (void) dealloc
{
    [_tasks release];
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
        _tasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setDelegate:(id<TasksDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(TasksDelegate)] )
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
    
    
    
    // Parameters are checked, perform the request:
    NSURLRequest *__exec_request = nil;
    
    
    if (_shouldUseAddress)
    {
    NSString* requestPath = (_type == VacantTask) ? @"mobile/task/withAddress/":@"mobile/inwork/all/";
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/%@", url, requestPath];
    nwReq.httpMethod = _http_method;
    //[nwReq addParam:@"userId" withValue:_userId];
    [nwReq addParam:@"token" withValue:_userSession];
    [nwReq addParam:@"latitude" withValue:[NSString stringWithFormat:@"%f", _latitude]];
    [nwReq addParam:@"longitude" withValue:[NSString stringWithFormat:@"%f", _longitude]];
    [nwReq addParam:@"page" withValue:@"1"];
    
    __exec_request = [nwReq buildURLRequest];
    }
    else
    {
        NSString* requestPath = @"mobile/task/withoutAddress/";
        
        NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
        nwReq.URL = [NSMutableString stringWithFormat:@"%@/%@", url, requestPath];
        nwReq.httpMethod = _http_method;
        //[nwReq addParam:@"userId" withValue:_userId];
        [nwReq addParam:@"token" withValue:_userSession];
        [nwReq addParam:@"page" withValue:@"1"];
        
        __exec_request = [nwReq buildURLRequest];
    }
    
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
            NSString *tasksKey = nil;
            if (_type == VacantTask)
                tasksKey = @"tasks";
            else
                tasksKey = @"inworks";
            
            NSArray *recievedTasks = nil;
            if ([result objectForKey:tasksKey])
                recievedTasks = [result objectForKey:tasksKey];
            
            NSEnumerator *enumerator = [recievedTasks objectEnumerator];
            NSDictionary *currTaskInfo = Nil;
            while ( (currTaskInfo = (NSDictionary*)[enumerator nextObject]) )
            {
                TaskInformation *taskInfo = [TaskInformation new];
                if (_type == VacantTask)
                    taskInfo.type = VacantTask;
                
                if (_type == AssignedTasks)
                    obj = [currTaskInfo objectForKey:@"tid"];
                else
                    obj = [currTaskInfo objectForKey:@"id"];
                
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.taskId = [NSString stringWithFormat:@"%ld", (long)[obj integerValue]];
                obj = [currTaskInfo objectForKey:@"iid"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.taskInworkId = [NSString stringWithFormat:@"%ld", (long)[obj integerValue]];
                obj = [currTaskInfo objectForKey:@"client_name"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.clientName = obj;
                obj = [currTaskInfo objectForKey:@"title"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.taskName = obj;
                obj = [currTaskInfo objectForKey:@"address"];
                if (obj && [obj isKindOfClass:[NSString class]] && ![obj isEqualToString:@""])
                    taskInfo.address = obj;
                obj = [currTaskInfo objectForKey:@"price"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.price = [obj intValue];
                obj = [currTaskInfo objectForKey:@"experience"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.experience = [obj intValue];
                obj = [currTaskInfo objectForKey:@"finishDateTime"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    [taskInfo setFinishDateFromString:obj];
                obj = [currTaskInfo objectForKey:@"distance"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.distance = [obj doubleValue];
                obj = [currTaskInfo objectForKey:@"latitude"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.latitude = [obj doubleValue];
                obj = [currTaskInfo objectForKey:@"longitude"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.longitude = [obj doubleValue];
                obj = [currTaskInfo objectForKey:@"description"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.taskDescription = obj;
                
                obj = [currTaskInfo objectForKey:@"status"];
                if (obj && [obj isKindOfClass:[NSString class]] && _type == AssignedTasks)
                {
                    NSInteger statusValue = [obj integerValue];
                    taskInfo.type = (statusValue == 0) ? AssignedTasks:PendingTask;
                }
                
                [_tasks addObject:taskInfo];
                [taskInfo release];
            }
            
            /*
             else
             {
             _resultCode = -1;
             [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
             }
             */
        }
        
        [dataString release];
    }
    
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
    {
        if (_type == VacantTask)
            [_delegate tasksComplete:_resultCode tasks:_tasks];
        else
            [_delegate assignedTasksComplete:_resultCode tasks:_tasks];
    }
}

@end
