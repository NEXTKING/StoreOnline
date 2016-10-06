//
//  NwObjRegister.h
//  Checklines
//
//  Created by Denis Kurochkin on 12.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

typedef enum
{
    StartRegisterStage = 1,
    ConfirmationRegisterStage = 2
} RegisterStage;

@interface NwObjRegister : NwObject
{
}

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <RegisterDelegate> delegate;
@property (nonatomic, readwrite, assign) RegisterStage stage;

// input parameters:
@property (nonatomic, retain) RegisterParams* regesterParams;
@property (nonatomic, copy)   NSString* activationCode;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
