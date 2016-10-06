//
//  NwobjTaskHistory.m
//  Checklines
//
//  Created by Kurochkin on 05/11/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwobjTaskHistory.h"
#import "Logger.h"
#import "SBJson.h"

@implementation NwobjTaskHistory

- (void) dealloc
{
    [_doneTasks release];
    [_checkedTasks release];
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
    }
    return self;
}

- (void) setDelegate:(id<TaskHistoryDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(TaskHistoryDelegate)] )
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
    
    NSString* requestPath = (_type == DoneTasks) ? @"mobile/inwork/checked/":@"mobile/inwork/checked/";
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/%@", url, requestPath];
    nwReq.httpMethod = _http_method;
   // [nwReq addParam:@"token" withValue:_userId];
    [nwReq addParam:@"page" withValue:@"1"];
    [nwReq addParam:@"token" withValue:_userSession];
    
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
           
            
            NSArray *recievedTasks = nil;
            if ([result objectForKey:@"inworks"])
                recievedTasks = [result objectForKey:@"inworks"];
            
            NSMutableArray *parsedTasks = [[NSMutableArray alloc] init];
            
            NSEnumerator *enumerator = [recievedTasks objectEnumerator];
            NSDictionary *currTaskInfo = Nil;
            while ( (currTaskInfo = (NSDictionary*)[enumerator nextObject]) )
            {
                TaskInformation *taskInfo = [TaskInformation new];
                
                obj = [currTaskInfo objectForKey:@"tid"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.taskId = [NSString stringWithFormat:@"%ld", (long)[obj integerValue]];
                obj = [currTaskInfo objectForKey:@"iid"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.taskInworkId = [NSString stringWithFormat:@"%ld", (long)[obj integerValue]];
                obj = [currTaskInfo objectForKey:@"title"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.taskName = obj;
                obj = [currTaskInfo objectForKey:@"clientName"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.clientName = obj;
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
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.distance = [obj doubleValue];
                obj = [currTaskInfo objectForKey:@"description"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.taskDescription = obj;
                obj = [currTaskInfo objectForKey:@"comment"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    taskInfo.comment = obj;
                obj = [currTaskInfo objectForKey:@"latitude"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.latitude = [obj doubleValue];
                obj = [currTaskInfo objectForKey:@"longitude"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.longitude = [obj doubleValue];
                obj = [currTaskInfo objectForKey:@"check_dt"];
                if (obj && [obj isKindOfClass:[NSString class]])
                    [taskInfo setCheckDateFromString:obj];
                
                obj = [currTaskInfo objectForKey:@"points"];
                if (obj && [obj isKindOfClass:[NSNumber class]])
                    taskInfo.points = [obj doubleValue];
                
                obj = [currTaskInfo objectForKey:@"status"];
                if (obj && [obj isKindOfClass:[NSString class]])
                {
                    NSInteger statusValue = [obj integerValue];
                    taskInfo.type = (statusValue == 3) ? AcceptedTast:RejectedTask;
                }

                
                [parsedTasks addObject:taskInfo];
                [taskInfo release];
            }
            
            if (_type == DoneTasks)
                self.doneTasks = parsedTasks;
            else
                self.checkedTasks = parsedTasks;
            
            [parsedTasks release];
            
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
        if (_type == DoneTasks)
            [_delegate doneTasksComplete:_resultCode tasks:_doneTasks];
        else
            [_delegate checkedTasksComplete:_resultCode tasks:_checkedTasks];
    }
}


@end
