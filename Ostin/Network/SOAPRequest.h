//
//  SOAPRequest.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/12/2016.
//  Copyright © 2016 Evgeny Seliverstov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOAPRequestResponse : NSObject
@property (nonatomic, readonly) NSError *error;

- (instancetype)initWithSOAPResponseData:(NSData *)data;
- (NSString *)valueForParam:(NSString *)param;
- (NSArray *)valuesForParam:(NSString *)param;
@end

@interface SOAPRequest : NSObject
- (SOAPRequestResponse *)soapRequestWithMethod:(NSString *)method prefix:(NSString *)prefix params:(NSDictionary *)params authValue:(NSString *)auth;
@end
