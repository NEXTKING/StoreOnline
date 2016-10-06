//
//  OperationResult.h
//  PaymentLibrary
//
//  Created by Denis Kurochkin on 08.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLBankSlip : NSObject

@property (nonatomic, strong) NSDictionary* bankInfo;

@end

@interface PLOperationResult : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString* authCode;
@property (nonatomic, copy) NSString* maskedNumber;
@property (nonatomic, copy) NSString* referenceNumber;
@property (nonatomic, assign) double balance;
@property (nonatomic, copy) NSString *errorLocalizedDescription;
@property (nonatomic, strong) PLBankSlip *bankSlip;

@end
