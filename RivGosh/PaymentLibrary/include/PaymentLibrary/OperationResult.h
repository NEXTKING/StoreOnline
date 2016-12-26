//
//  OperationResult.h
//  PaymentLibrary
//
//  Created by Denis Kurochkin on 08.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CardVerificationMethod
{
    CVMPINOnline = 1,
    CVMSignature = 3,
    CVMNoCVM     = 4,   //mostly for nfc
    CVMPINOffline= 8
    
}CardVerificationMethod;

@interface PLOperationResult : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString* authCode;
@property (nonatomic, copy) NSString* maskedNumber;
@property (nonatomic, copy) NSString* referenceNumber;
@property (nonatomic, copy) NSString* cardholderName;
@property (nonatomic, assign) double balance;
@property (nonatomic, assign) double reconciliationAmount;
@property (nonatomic, copy) NSString *errorLocalizedDescription;
@property (nonatomic, copy) NSString* aid;
@property (nonatomic, copy) NSString* terminalID;
@property (nonatomic, copy) NSString* merchantID;
@property (nonatomic, strong) NSArray* operationsHistory;
@property (nonatomic, assign) CardVerificationMethod cvm;

@end
