//
//  NwobjPesonalInfo.h
//  Checklines
//
//  Created by Kurochkin on 29/10/14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol.h"

@interface NwobjPesonalInfo : NwObject

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <PersonalInfoDelegate> delegate;

// input parameters:
@property (nonatomic, readwrite, copy) NSString* userId;
@property (nonatomic, readwrite, copy) NSString* userSession;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@property (readonly, copy) NSString* name;
@property (readonly, assign) NSInteger experience;
@property (readonly, assign) NSInteger price;
@property (readonly, assign) NSInteger pays;
@property (readonly, assign) double reliability;

@end
