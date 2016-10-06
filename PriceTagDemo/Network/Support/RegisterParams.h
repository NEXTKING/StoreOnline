//
//  RegisterParams.h
//  Checklines
//
//  Created by Denis Kurochkin on 12.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterParams : NSObject

@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* email;

@end
