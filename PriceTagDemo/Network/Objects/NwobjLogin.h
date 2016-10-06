//
//  NwobjLogin.h
//  Checklines
//
//  Created by Denis Kurochkin on 18.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjLogin : NwObject
{
    //@private
    //NSString *_accessToken;
    //@private
    //NSString *_userId;
}

- (void) run: (const NSString*) url;
- (void) cancel;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, assign) id <LoginDelegate> delegate;

// input parameters:
@property (readwrite, copy) NSString* userPhone;
@property (readwrite, copy) NSString* userPassword;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
