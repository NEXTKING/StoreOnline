//
//  NwobjCards.h
//  MobileBanking
//
//  Created by Sergey Sasin on 29.04.13.
//  Copyright (c) 2013 BPC. All rights reserved.
//

#import "MCProtocol.h"
#import "NwObject.h"

@interface NwobjCards : NwObject
{
@protected
    NSMutableArray *_cardsList;
}

- (void) run: (const NSString*) url;
- (void) complete: (BOOL) isSuccessfull;

@property (nonatomic, readwrite, retain) id <CardsDelegate> delegate;

// input parameters:
@property (readwrite, copy) NSString* accessToken;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readonly, retain) NSArray* cardsList;

@end
