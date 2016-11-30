//
//  UserInformation.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 28/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject

@property (nonatomic, copy) NSString *key_user;
@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *name;

@end
