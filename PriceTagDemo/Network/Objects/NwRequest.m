//
//  NwRequest.m
//  MobileBanking
//
//  Created by power on 20.11.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import "NwRequest.h"
//#import "SecKeyWrapper.h"

#import "Logger.h"

@implementation NwRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        _URL = nil;
        _httpMethod = HTTP_METHOD_GET;
        //_signature = NO;
        _params = nil;
        _cookies = nil;
    }
    return self;
}

- (void)dealloc
{
}

- (void) setURL:(NSString *)URL
{
    _URL = nil;
    if ( URL )
        _URL = [URL mutableCopy];
}

- (void) setParams:(NSDictionary *)params
{
    _params = nil;
    if ( params )
        _params = [params mutableCopy];
}

- (void) setCookies:(NSDictionary *)cookies
{
    _cookies = nil;
    if ( cookies )
        _cookies = [cookies mutableCopy];
}

- (void) addParam:(NSString*)name withValue:(NSString*)value
{
    if ( !_params )
        _params = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [_params setObject:value forKey:name];
}

- (void) addCookie:(NSString*)name withValue:(NSString*)value
{
    if ( !_cookies )
        _cookies = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    [_cookies setObject:value forKey:name];
}

- (void) clear
{
    self.URL = Nil;
    self.httpMethod = HTTP_METHOD_GET;
    //self.signature = NO;
    if ( _params )
        [_params removeAllObjects];
    if ( _cookies )
        [_cookies removeAllObjects];
}

- (char) intToHexChar:(int)hex
{
    if ( hex >= 0 && hex <= 9 )
        return ('0'+hex);
    if ( hex >= 0x0a && hex <= 0x0f )
        return ('a'+(hex-0x0a));
    return -1;
}

- (NSString *) dataToString:(NSData*)data
{
    const NSInteger _bytes_len = data.length;
    const char *_bytes = data.bytes;
    if ( !_bytes )
        return Nil;
    
    NSMutableString *f_ret = [[NSMutableString alloc] init];
    for ( int i=0; i<_bytes_len; ++i )
        [f_ret appendFormat:@"%c%c", [self intToHexChar:((_bytes[i]>>4)&0x0f)], [self intToHexChar:(_bytes[i]&0x0f)]];
    
#ifdef DEBUG
    [Logger log:self method:@"dataToString" format:@"Original data: %@", [data description]];
    [Logger log:self method:@"dataToString" format:@"Result string: %@", f_ret];
#endif
    
    return f_ret;
}

/*- (NSString *) textSignature:(NSString*)text
{
    NSData *_signature_data = [[SecKeyWrapper instance] getSignatureBytes:[text dataUsingEncoding:NSUTF8StringEncoding]];
    if ( _signature_data )
    {
        return [self dataToString:_signature_data];
    }
    
    return Nil;
}
*/

- (NSURLRequest*) buildURLRequest
{
    // Check input parameters:
    if ( _URL == Nil )
        return Nil;
    if ( _httpMethod != HTTP_METHOD_GET && _httpMethod != HTTP_METHOD_POST && _httpMethod != HTTP_METHOD_PUT)
        return Nil;
    
    // Parameters are checked, build the request:

    NSMutableString *_str_params = [[NSMutableString alloc] init] ;
    if ( _params && _params.count > 0 )
    {
        NSEnumerator *enumerator = [_params keyEnumerator];
        NSString *paramName = Nil;
        NSString *paramValue = Nil;
        while ( (paramName = (NSString*)[enumerator nextObject]) )
        {
            if ( _str_params.length > 0 )
                [_str_params appendString:@"&"];
            
            paramValue = [_params objectForKey:paramName];
#ifdef DEBUG
            [Logger log:self method:@"buildURLRequest" format:@"Dump params: %@=%@", paramName, paramValue];
#endif
            
            [_str_params appendFormat:@"%@=%@", paramName, [self percentEncode:paramValue]];
        }
    }
#ifdef DEBUG
    [Logger log:self method:@"buildURLRequest" format:@"Params: %@", _str_params];
#endif
    
    NSMutableString *_str_cookies = [[NSMutableString alloc] init];
    if ( _cookies && _cookies.count > 0 )
    {
        NSEnumerator *enumerator = [_cookies keyEnumerator];
        NSString *cookieName = Nil;
        NSString *cookieValue = Nil;
        while ( (cookieName = (NSString*)[enumerator nextObject]) )
        {
            if ( _str_cookies.length > 0 )
                [_str_cookies appendString:@"; "];
            
            cookieValue = [_cookies objectForKey:cookieName];
#ifdef DEBUG
            [Logger log:self method:@"buildURLRequest" format:@"Dump cookies: %@=%@", cookieName, cookieValue];
#endif
            [_str_cookies appendFormat:@"%@=%@", cookieName, [self percentEncode:cookieValue]];
        }
    }
    
#ifdef DEBUG
    [Logger log:self method:@"buildURLRequest" format:@"Cookies: %@", _str_cookies];
#endif
    
    // Digital signature
    /*
    if ( _signature )
    {
        if ( _str_params.length > 0 )
            [_str_params appendString:@"&"];
        
        NSMutableString *_str_params_tmp = [_str_params mutableCopy];
        [_str_params_tmp appendString:@"stamp=00000000000000000000"];
        NSString *_str_signature = [self textSignature:_str_params_tmp];
        [_str_params appendFormat:@"stamp=%@", _str_signature];
        [_str_params_tmp release];
    }
    //
     */
    
    NSString *escapedUrl    = [_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *escapedParams = [_str_params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *_exec_url = Nil;
    if ( _httpMethod == HTTP_METHOD_GET )
    {
        if ( _str_params.length > 0 )
            _exec_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", escapedUrl, escapedParams]];
        else
            _exec_url = [NSURL URLWithString:_URL];
    }
    else
    if ( _httpMethod == HTTP_METHOD_POST || _httpMethod == HTTP_METHOD_PUT )
    {
        _exec_url = [NSURL URLWithString:escapedUrl];
    }
    if ( !_exec_url )
        return Nil;

#ifdef DEBUG
    [Logger log:self method:@"buildURLRequest" format:@"HTTP URL:\n%@", _exec_url.absoluteString];
#endif
    
    NSMutableURLRequest *_exec_request = [NSMutableURLRequest requestWithURL:_exec_url];
    if ( !_exec_request )
        return Nil;
    
    _exec_request.timeoutInterval = 1000;
    
    [_exec_request setHTTPShouldHandleCookies:NO];
    [_exec_request addValue:_str_cookies forHTTPHeaderField:@"Cookie"];
    [_exec_request setValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
#if RIVGOSH
    [_exec_request addValue:@"Basic 0JDQtNC80LjQvdC40YHRgtGA0LDRgtC+0YA6" forHTTPHeaderField:@"Authorization"];
#endif
    if ( _httpMethod == HTTP_METHOD_POST || _httpMethod == HTTP_METHOD_PUT)
    {
        NSMutableData *httpBody = [[NSMutableData alloc] init] ;
        [httpBody appendData:[escapedParams dataUsingEncoding: NSUTF8StringEncoding]];
        [httpBody appendData:[_rawBody dataUsingEncoding:NSUTF8StringEncoding]];
#ifdef DEBUG
        NSString *bodyDump = [[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding];
        [Logger log:self method:@"buildURLRequest" format:@"HTTP Body dump:\n%@", bodyDump];
        bodyDump = nil;
#endif
        
        NSString* methodString = (_httpMethod == HTTP_METHOD_POST) ? @"POST":@"PUT";
        [_exec_request setHTTPMethod:methodString];
        [_exec_request setHTTPBody: httpBody];
    }
    else
    if ( _httpMethod == HTTP_METHOD_GET )
    {
        [_exec_request setHTTPMethod:@"GET"];
    }
    
    return _exec_request;
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
    NSString *encodedResult = [NSString stringWithString:(__bridge NSString*) encodedString];
    CFRelease(encodedString);
    
    return encodedResult;
}


@end
