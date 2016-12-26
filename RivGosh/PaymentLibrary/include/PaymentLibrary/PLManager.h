//
//  PaymentLibrary.h
//  PaymentLibrary
//
//  Created by Denis Kurochkin on 08.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationResult.h"

typedef enum : NSInteger
{
    PLOperationTypeNone = 0,
    PLOperationTypeSignOn = 1,
    PLOperationTypeKeyExchange = 2,
    PLOperationTypeBalance = 3,
    PLOperationTypePayment = 4,
    PLOperationTypeReversal = 5,
    PLOperationTypeSettings = 6,
    PLOperationTypeReconciliation = 7,
    PLOperationTypeCutover = 8,
    PLOperationTypeHistory = 9
}PLOperationType;


@protocol PLManagerDelegate <NSObject>

- (void) paymentManagerWillRequestCardSwipe;
- (void) paymentManagerDidReceiveCardSwipe;
- (void) paymentManagerWillRequestPINEntry;
- (void) paymentManagerDidReceivePINEntry:(BOOL) success;

@optional
//The transaction is about to be sent to processing
- (void) paymentManagerWillStartOperation: (PLOperationType) operation;
//Called in both positive and negative results. The detailed information is stored within result parameter.
- (void) paymentManagerDidFinishOperation: (PLOperationType) operation result:(PLOperationResult*) result;

@end




@interface PLManager : NSObject

@property (nonatomic, weak) id<PLManagerDelegate> delegate;
@property (nonatomic, copy) NSString* serverAddress;

+ (instancetype) instance;

//ALL THE METHODS ARE ASYNCHRONIOUS. Operation status is supposed to be received through the delegate methods (mostly out of OperationResult object)

// Say hello to processing (connnection check)
- (void) signOn: (NSError**) error;
// Session key exchange (for PIN block encryption)
- (void) keyEchange: (NSError**) error;

- (void) checkBalance: (NSError**) error;
- (void) payment: (double) amount error: (NSError**) error;
- (void) reconciliation: (double) amount error: (NSError**) error;
- (void) reversal: (double) amount referenceNumber:(NSString*) reference error: (NSError**) error;
- (void) endOfDay:(NSError **)error;
- (void) updateTerminalSettings:(NSError**)error;
- (void) cancelAllOperations;
- (void) operationsHistory:(NSError**) error;


@end
