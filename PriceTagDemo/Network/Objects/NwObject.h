//
//  NwObject.h
//  MobileBanking
//
//  Created by Sergey Sasin on 15.04.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NwRequest.h"

@protocol INwObject <NSObject>

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;
- (void) cancel;

@property(nonatomic, copy) NSError* error;
@property(nonatomic, strong) NSProgress *progress;

@end

@interface NwObject : NSObject
    <NSURLConnectionDelegate, INwObject>
{
@protected
    HTTPMethod              _http_method;
    NSURL*                  _exec_url;
    NSMutableURLRequest*    _exec_request;
    NSURLConnection*        _exec_connection;
    NSMutableData*          _exec_data;
    
    NSMutableDictionary*    _cookies;
    NSDictionary*         _unsortedCookies;
}


- (NSString*) percentEncode:(NSString*)clearValue;
- (NSString*) percentDecode:(NSString*)percentValue;


@end
