//
//  NwObjPasswordRecovery.h
//  Checklines
//
//  Created by Kurochkin on 07/11/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

typedef enum
{
    StartRecoveryStage = 1,
    ConfirmationRecoveryStage = 2
} RecoveryStage;

@interface NwObjPasswordRecovery : NwObject

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <PasswordRecoveryDelegate> delegate;
@property (nonatomic, readwrite, assign) RecoveryStage stage;

// input parameters:
@property (nonatomic, copy) NSString* phoneNumber;
@property (nonatomic, copy) NSString* activationCode;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* email;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
