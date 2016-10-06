//
//  NwRequest.h
//  MobileBanking
//
//  Created by power on 20.11.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    HTTP_METHOD_GET = 0,
    HTTP_METHOD_POST = 1,
    HTTP_METHOD_PUT  = 2
} HTTPMethod;

@interface NwRequest : NSObject
{
@protected
    NSMutableString *_URL;
    NSMutableDictionary *_params;
    NSMutableDictionary *_cookies;
}

@property (nonatomic, readwrite, copy) NSString* URL;
@property (nonatomic, readwrite, assign) HTTPMethod httpMethod;
//@property (nonatomic, readwrite, assign) BOOL signature;
@property (nonatomic, readwrite, copy) NSDictionary* params;
@property (nonatomic, readwrite, copy) NSDictionary* cookies;
@property (nonatomic, readwrite, copy) NSString* rawBody;

- (void) addParam:(NSString*)name withValue:(NSString*)value;
- (void) addCookie:(NSString*)name withValue:(NSString*)value;

- (void) clear;
- (NSURLRequest*) buildURLRequest;
- (NSString *) dataToString:(NSData*)data;

@end
