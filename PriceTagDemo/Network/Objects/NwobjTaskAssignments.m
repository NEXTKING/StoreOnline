//
//  NwobjTaskAssignments.m
//  Checklines
//
//  Created by Denis Kurochkin on 05.11.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwobjTaskAssignments.h"
#import "Logger.h"
#import "SBJson.h"
#import "ReportInformation.h"
#import "PhotoInformation.h"
#import "QuizInformation.h"

@implementation NwobjTaskAssignments

- (void) dealloc
{
    [_taskId release];
    [_delegate release];
    [_taskInfo release];
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
        _taskId = nil;
    }
    return self;
}

- (void) setDelegate:(id<TaskAssignmentsDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ( [delegate conformsToProtocol:@protocol(TaskAssignmentsDelegate)] )
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        if (_delegate)
            [_delegate release];
        
        _delegate = [delegate retain];
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (NSString*) generateJsonForTask
{
    NSMutableString *resultString = [[[NSMutableString alloc] init] autorelease];
    [resultString appendFormat:@"{\"iid\":\"%@\",\"latitude\":\"%f\",\"longitude\":\"%f\",\"points\":[", _taskInfo.taskInworkId, _coorditane.latitude, _coorditane.longitude];
    NSInteger numberOfForms = _taskInfo.blanks.count;
    NSInteger currentForm = 0;
    
    for (int i = 0; i < _taskInfo.blanks.count; ++i) {
        
        currentForm++;
        BlankInformation *blankInfo = _taskInfo.blanks[i];
        
        if ([blankInfo isKindOfClass:[ReportInformation class]])
        {
            ReportInformation* reportInfo = (ReportInformation*)blankInfo;
            [resultString appendFormat:@"{\"pid\":\"%@\",", reportInfo.formId];
            [resultString appendFormat:@"\"content\":\"%@\"}", reportInfo.answer];
            if (currentForm < numberOfForms)
                [resultString appendString:@","];

        }
        else if ([blankInfo isKindOfClass:[PhotoInformation class]])
        {
            PhotoInformation* photoInfo = (PhotoInformation*)blankInfo;
            [resultString appendFormat:@"{\"pid\":\"%@\",", photoInfo.formId];
            [resultString appendFormat:@"\"content\":\"%@\"}", [NSString stringWithFormat:@"photo_%d", i]];
            if (currentForm < numberOfForms)
                [resultString appendString:@","];
        }
        else if ([blankInfo isKindOfClass:[QuizInformation class]])
        {
            QuizInformation* quizInfo = (QuizInformation*)blankInfo;
            [resultString appendFormat:@"{\"pid\":\"%@\",", quizInfo.formId];
            [resultString appendFormat:@"\"content\":%@}", [quizInfo generateJSON]];
            if (currentForm < numberOfForms)
                [resultString appendString:@","];
            
        }
    }
    
    [resultString appendString:@"]}"];
    
    return resultString;
    
}

- (NSURLRequest*)generateUrlRequestWithUrl:(NSString*)url
{
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];
    //[_params setObject:@"cp-1251" forKey:@"charset"];
    //[_params setObject:@"photo.png" forKey:@"content"];
    [_params setObject:[self generateJsonForTask] forKey:@"task"];
    //[_params setObject:@"title" forKey:@"title"];
    //[_params setObject:_userId forKey:@"userId"];
    [_params setObject:_userSession forKey:@"token"];
    //[_params setObject:[NSString stringWithFormat:@"%f", _coorditane.latitude] forKey:@"latitude"];
    //[_params setObject:[NSString stringWithFormat:@"%f", _coorditane.longitude] forKey:@"longitude"];
    
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [_params release];
    NSString* bodyDump = [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease];
    [Logger log:self method:@"generateJson" format:bodyDump];
    
    for (int i = 0; i < _taskInfo.photos.count; ++i )
    {
        PhotoInformation *photoInfo = [_taskInfo.photos objectAtIndex:i];
        UIImage *imageToAppend = photoInfo.image;
        
        NSInteger photoIndex = [_taskInfo.blanks indexOfObject:photoInfo];
        [self appdendImageData:imageToAppend toMutableData:body withFileName:[NSString stringWithFormat:@"photo_%ld", (long)photoIndex]];
    }
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/mobile/inwork/do", url]]];
    
    return request;
}


- (void) appdendImageData:(UIImage*)image toMutableData:(NSMutableData*)data withFileName:(NSString*)fileName
{
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    UIImage *imageToPost = image;
    NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
    if (imageData) {
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileName,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:imageData];
        [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void) run: (NSString*) url
{
    // Check input parameters:
    
    if ( (_taskId == Nil && _type != ATUploadTask) || (_taskInfo.taskInworkId == Nil && _type == ATUploadTask) )
    {
        [Logger log:self method:@"run" format:@"'taskId' property is not set"];
        [self complete:NO];
        return;
    }
    
    if ( _userSession == Nil )
    {
        [Logger log:self method:@"run" format:@"'userSession' property is not set"];
        [self complete:NO];
        return;
    }
    
    /*if ( _taskId == Nil )
    {
        [Logger log:self method:@"run" format:@"'task ID' property is not set"];
        [self complete:NO];
        return;
    } */
    
    NSString* requestPath = (_type == ATAddTask) ? @"mobile/task/take":@"mobile/inwork/cancel/";
    if (_type == ATUploadTask)
        requestPath = @"mobile/inwork/do";
    
    // Parameters are checked, perform the request:
    
    NwRequest *nwReq = [[[NwRequest alloc] init] autorelease];
    nwReq.URL = [NSMutableString stringWithFormat:@"%@/%@", url, requestPath];
    nwReq.httpMethod = HTTP_METHOD_POST;
    
    NSURLRequest *__exec_request = nil;
    
    if (_type != ATUploadTask)
    {
        [nwReq addParam:@"token" withValue:_userSession];
        [nwReq addParam:@"tid" withValue:_taskId];
        __exec_request = [nwReq buildURLRequest];
    }
    else
    {
        __exec_request = [self generateUrlRequestWithUrl:url];
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
    NSString *iid = nil;
    
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
        
        //id obj = nil;
        
        if ( _resultCode == 0 )
        {
            
            id obj = [result objectForKey:@"iid"];
            if (obj && [obj isKindOfClass:[NSNumber class]])
                iid = [NSString stringWithFormat:@"%ld", (long)[obj integerValue]];
            /*
             else
             {
             _resultCode = -1;
             [Logger log:self method:@"complete" format:@"'accessToken' is not found"];
             }yyyy-MM-dd HH:mm:ss             */
        }
        
        [dataString release];
    }
    
    // Send signal to delegate
    // If delegate is not NIL, it conforms to correct protocol
    if ( _delegate )
    {
        if (_type == ATAddTask)
            [_delegate taskAssignComplete:_resultCode iid:iid];
        else if (_type == ATRemoveTask)
            [_delegate taskRemoveComplete:_resultCode];
        else if (_type == ATUploadTask)
            [_delegate taskUploadComplete:_resultCode];
    }
}


- (NSString*) percentEncode:(NSString*)clearValue
{
    //NSString *_encodedValue = [clearValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(
                                                                        kCFAllocatorDefault,
                                                                        (CFStringRef)clearValue,
                                                                        NULL,
                                                                        CFSTR(":/?#[]@!$&'()*+,;="),
                                                                        kCFStringEncodingUTF8);
    NSString *encodedResult = [NSString stringWithString:(NSString*) encodedString];
    CFRelease(encodedString);
    
    return encodedResult;
}

@end
