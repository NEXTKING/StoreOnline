//
//  SOAPRequest.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/12/2016.
//  Copyright © 2016 Evgeny Seliverstov. All rights reserved.
//

#import "SOAPRequest.h"

@interface SOAPRequestResponse ()
@property (nonatomic, copy) NSString *xmlString;
@end

@implementation SOAPRequestResponse

- (instancetype)initWithSOAPResponseData:(NSData *)data
{
    self = [super init];
    
    if (self)
    {
        if (data)
            _xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        else
            _error = [NSError errorWithDomain:@"com.dataphone.Ostin" code:200 userInfo:@{NSLocalizedDescriptionKey:@"SOAPRequestResponse: nil data"}];
    }
    
    return self;
}

- (NSString *)valueForParam:(NSString *)param
{
    if (!_xmlString)
        return nil;
    
    NSRange start = [_xmlString rangeOfString:[NSString stringWithFormat:@"<%@>", param]];
    NSRange end = [_xmlString rangeOfString:[NSString stringWithFormat:@"</%@>", param]];
    if ((start.location != NSNotFound) && (end.location != NSNotFound))
    {
        NSRange range = NSMakeRange(start.location + start.length, end.location - start.location - start.length);
        return [_xmlString substringWithRange:range];
    }
    else
        return nil;
}

- (NSArray *)valuesForParam:(NSString *)param
{
    if (!_xmlString)
        return nil;
    
    NSMutableString *tempXMLString = [_xmlString mutableCopy];
    NSMutableArray *values = [NSMutableArray array];
    NSRange range = [tempXMLString rangeOfString:[NSString stringWithFormat:@"<%@>", param]];
    while (range.location != NSNotFound)
    {
        [tempXMLString deleteCharactersInRange:NSMakeRange(0, range.location + param.length + 2)];
        NSRange end = [tempXMLString rangeOfString:[NSString stringWithFormat:@"</%@>", param]];
        if (end.location != NSNotFound)
        {
            NSString *str = [tempXMLString substringToIndex:end.location];
            NSString *decodedStr = [[[[[[str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]
                                    stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""]
                                   stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"]
                                  stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
                                 stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
                                stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
            [values addObject:decodedStr];
            [tempXMLString deleteCharactersInRange:NSMakeRange(0, end.location + param.length + 3)];
            range = [tempXMLString rangeOfString:[NSString stringWithFormat:@"<%@>", param]];
        }
        else
            range.location = NSNotFound;
    }
    return values;
}

@end

@interface SOAPRequest()
@property (nonatomic, retain) NSURLSession *urlSession;
@end

@implementation SOAPRequest

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 300.0;
        sessionConfiguration.timeoutIntervalForResource = 300.0;
        
        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return self;
}

- (SOAPRequestResponse *)soapRequestWithMethod:(NSString *)method prefix:(NSString *)prefix params:(NSDictionary *)params authValue:(NSString *)auth
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[self serviceURL]];
    [urlRequest setValue:auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:[NSString stringWithFormat:@"\"%@\"", method] forHTTPHeaderField:@"SOAPAction"];
    [urlRequest setValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[self generateSOAPBodyForMethod:method prefix:prefix params:params]];
    
    // synchronous request
    __block NSData *responseData = nil; dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    [[_urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil)
            responseData = data;
        
        dispatch_semaphore_signal(sem);
    }] resume];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    SOAPRequestResponse *soapResponse = [[SOAPRequestResponse alloc] initWithSOAPResponseData:responseData];
    return soapResponse;
}

- (NSData *)generateSOAPBodyForMethod:(NSString *)method prefix:(NSString *)prefix params:(NSDictionary *)params
{
    NSString* (^xmlEscape)(NSString *) = ^(NSString *_string)
    {
        return [[[[[_string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
                   stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
                  stringByReplacingOccurrencesOfString:@"'" withString:@"&#39;"]
                 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
                stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    };
    
    NSString* (^removeOrderPrefix)(NSString *) = ^(NSString *_string)
    {
        if (_string.length > 3)
        {
            NSRange r = [_string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
            return (r.location == NSNotFound) ? _string : [_string substringFromIndex:2];
        }
        else
            return _string;
    };
    
    NSString* (^bodyForParams)(NSDictionary *_params);
    NSString* (^ __block __weak weakBodyForParams)(NSDictionary *_params);
    weakBodyForParams = bodyForParams = ^(NSDictionary *_params)
    {
        NSMutableString *element = [[NSMutableString alloc] init];
        
        NSArray *paramKeys = [[_params allKeys] sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *paramKey in paramKeys)
        {
            id paramValue = [_params objectForKey:paramKey];
            
            if ([paramValue isKindOfClass:[NSString class]])
                [element appendFormat:@"<pi:%@>%@</pi:%@>", removeOrderPrefix(paramKey), xmlEscape(paramValue), removeOrderPrefix(paramKey)];
            else if ([paramValue isKindOfClass:[NSNull class]])
                [element appendFormat:@"<pi:%@/>", removeOrderPrefix(paramKey)];
            else if ([paramValue isKindOfClass:[NSDictionary class]])
                [element appendFormat:@"<pi:%@>%@</pi:%@>", removeOrderPrefix(paramKey), weakBodyForParams(paramValue), removeOrderPrefix(paramKey)];
            else if ([paramValue isKindOfClass:[NSArray class]])
            {
                [element appendFormat:@"<pi:%@>", removeOrderPrefix(paramKey)];
                for (id child in paramValue)
                    [element appendString:weakBodyForParams(child)];
                [element appendFormat:@"</pi:%@>", removeOrderPrefix(paramKey)];
            }
        }
        return element;
    };
    
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    [bodyString appendString:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:pi=\"http://xmlns.oracle.com/orawsv/SHOP_WEB/PI_MOBILE_SERVICE\">"];
    [bodyString appendString:@"<soapenv:Header/>"];
    [bodyString appendString:@"<soapenv:Body>"];
    [bodyString appendFormat:@"<pi:%@%@Input>", prefix?prefix:@"", method];
    [bodyString appendString:bodyForParams(params)];
    [bodyString appendFormat:@"</pi:%@%@Input>", prefix?prefix:@"", method];
    [bodyString appendString:@"</soapenv:Body>"];
    [bodyString appendString:@"</soapenv:Envelope>"];

    return [bodyString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL *)serviceURL
{
    NSString *protocol = [[NSUserDefaults standardUserDefaults] valueForKey:@"protocol_preference"];
    NSString *host     = [[NSUserDefaults standardUserDefaults] valueForKey:@"host_preference"];
    NSString *port     = [[NSUserDefaults standardUserDefaults] valueForKey:@"port_preference"];
    NSString *path     = [[NSUserDefaults standardUserDefaults] valueForKey:@"path_preference"];
    NSMutableString *address = [NSMutableString stringWithFormat:@"%@://%@%@",protocol, host, port.length > 0?[NSString stringWithFormat:@":%@", port]:@""];
    if (path.length > 0)
        [address appendFormat:@"/%@", path];
    
    //return [NSURL URLWithString:address];
    //return [NSURL URLWithString:@"http://172.16.4.234:8080/orawsv/OST170_WEB/PI_MOBILE_SERVICE"];
    return [NSURL URLWithString:@"http://172.16.1.93:8080/orawsv/SHOP_WEB/PI_MOBILE_SERVICE"];
}

@end
