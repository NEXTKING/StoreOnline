//
//  Logger.h
//  MobileBanking
//
//  Created by Sergey Sasin on 15.04.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject

+ (void) log:(id) k method:(NSString*) m format:(NSString*) f, ...;

@end

#ifdef DEBUG
#define LOGGER_LOGAUTO(f, ...) {[Logger log:Nil method:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] format:f, ##__VA_ARGS__];}
#define LOGGER_LOGSELF(m, f, ...) {[Logger log:self method:m format:f, ##__VA_ARGS__];}
#define LOGGER_LOG(k, m, f, ...) {[Logger log:k method:m format:f, ##__VA_ARGS__];}
#else
#define LOGGER_LOGAUTO(f, ...) {}
#define LOGGER_LOGSELF(m, f, ...) {}
#define LOGGER_LOG(k, m, f, ...) {}
#endif
