//
//  MCProtocol+RivGosh.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 23.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#ifndef MCProtocol_RivGosh_h
#define MCProtocol_RivGosh_h
#import "Delegates+RivGosh.h"
#import "MCProtocol.h"

#endif /* MCProtocol_RivGosh_h */

@protocol MCProtocolRivGosh <MCProtocol>

- (void) applyDiscounts:(id<ApplyDiscountsDelegate>)delegate  discounts:(NSArray*) discounts receiptId:(NSString*) rid;
- (void) restartPrintQueue:(id<PrinterDelegate>) delegate;
- (void) repeatPrint:(id<PrinterDelegate>)delegate type:(NSString*) type receiptID:(NSString*)receiptID reqId:(id)reqId;
- (void) printStatus:(id<PrinterDelegate>)delegate receiptId:(NSString*) receiptId;
- (void) sendPayment:(id<SendPaymentDelegate>)delegate amount:(double) amount authCode:(NSString*)authCode transactionCode:(NSString*) transactionCode card:(NSString*)card receiptId:(NSString*)receiptId;
- (void) sendLoyalty:(id<SendPaymentDelegate>)delegate receiptId:(NSString*)receiptId;
- (void) openShift:(id<PrinterDelegate>) delegate date:(NSDate*) date;
- (void) xReport: (id<PrinterDelegate>)delegate;
- (void) zReport: (id<PrinterDelegate>)delegate receiptID:(NSString*)receiptID amount:(NSNumber*) amount reqID:(id)reqID;

@end