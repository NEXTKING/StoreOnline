//
//  NwobjSendPayment.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 01.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "NwObject.h"
#import "MCProtocol+RivGosh.h"

@interface NwobjSendPayment : NwObject

@property (nonatomic, weak) id <SendPaymentDelegate> delegate;
@property (nonatomic, copy) NSString* processingResult;
@property (nonatomic, copy) NSString* receiptID;
@property (nonatomic, copy) NSString* authCode;
@property (nonatomic, copy) NSString* referenceNumber;
@property (nonatomic, copy) NSString* terminalID;
@property (nonatomic, copy) NSString* merchantID;
@property (nonatomic, copy) NSString* cardholderName;
@property (nonatomic, copy) NSString* aid;
@property (nonatomic, copy) NSString* card;
@property (nonatomic, assign) double amount;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;
@property (readwrite, copy) NSString* accessToken;
@property (readwrite, copy) NSString* userId;

@end
