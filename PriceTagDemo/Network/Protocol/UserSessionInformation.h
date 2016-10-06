//
//  UserSessionInformation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 30.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSessionInformation : NSObject

@property (nonatomic, copy) NSString* cashName;
@property (nonatomic, copy) NSString* cashboxName;
@property (nonatomic, copy) NSString* storeName;

@end
