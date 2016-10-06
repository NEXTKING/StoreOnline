//
//  NwobjSendLoyalty.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 02.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol+RivGosh.h"

@interface NwobjSendLoyalty : NwObject

@property (nonatomic, weak) id <SendPaymentDelegate> delegate;
@property (nonatomic, copy) NSString* receiptID;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
