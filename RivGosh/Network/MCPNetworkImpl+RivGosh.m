//
//  MCPNetworkImpl+RivGosh.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 23.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MCPNetworkImpl+RivGosh.h"
#import "NwobjApplyDiscounts.h"
#import "NwobjRestartPrintQueue.h"
#import "NwobjPrintStatus.h"
#import "NwobjSendPayment.h"
#import "NwobjSendLoyalty.h"
#import "NwobjOpenShift.h"
#import "NwobjPrintRepeat.h"
#import "NwobjectXReport.h"
#import "NwobjZreport.h"
#import "NwobjPrintText.h"

@implementation MCPNetworkImpl_RivGosh

- (void) applyDiscounts:(id<ApplyDiscountsDelegate>)delegate discounts:(NSArray *)discounts receiptId:(NSString *)rid
{
    NwobjApplyDiscounts *nwobjDiscounts = [NwobjApplyDiscounts new];
    nwobjDiscounts.delegate = delegate;
    nwobjDiscounts.discounts = discounts;
    nwobjDiscounts.receiptID = rid;
    [nwobjDiscounts run:self.serverAddress];
}

- (void) restartPrintQueue:(id<PrinterDelegate>)delegate
{
    NwobjRestartPrintQueue *restart = [NwobjRestartPrintQueue new];
    restart.delegate = delegate;
    [restart run:self.serverAddress];    
}

- (void) sendPayment:(id<SendPaymentDelegate>)delegate operation:(PLOperationResult *)operation receiptId:(NSString *)receiptId amount:(double)amount
{
    NwobjSendPayment *nwobjSendPayment = [NwobjSendPayment new];
    nwobjSendPayment.delegate = delegate;
    nwobjSendPayment.authCode = operation.authCode;
    nwobjSendPayment.amount = amount;
    nwobjSendPayment.referenceNumber = operation.referenceNumber;
    nwobjSendPayment.card = operation.maskedNumber;
    nwobjSendPayment.receiptID = receiptId;
    nwobjSendPayment.cardholderName = operation.cardholderName;
    nwobjSendPayment.processingResult = @"000";
    nwobjSendPayment.terminalID = operation.terminalID;
    nwobjSendPayment.merchantID = operation.merchantID;
    nwobjSendPayment.aid = operation.aid;
    
    [nwobjSendPayment run:self.serverAddress];
}
- (void) printStatus:(id<PrinterDelegate>)delegate receiptId:(NSString *)receiptId
{
    NwobjPrintStatus *nwobjPrintStatus = [NwobjPrintStatus new];
    nwobjPrintStatus.delegate = delegate;
    nwobjPrintStatus.receiptID = receiptId;
    [nwobjPrintStatus run:self.serverAddress];
}

- (void) sendLoyalty:(id<SendPaymentDelegate>)delegate receiptId:(NSString *)receiptId
{
    NwobjSendLoyalty *nwobjSendLoyalty = [NwobjSendLoyalty new];
    nwobjSendLoyalty.delegate = delegate;
    nwobjSendLoyalty.receiptID = receiptId;
    [nwobjSendLoyalty run:self.serverAddress];
}

- (void) openShift:(id<PrinterDelegate>)delegate date:(NSDate *)date
{
    NwobjOpenShift *nwobjOpenShift = [NwobjOpenShift new];
    nwobjOpenShift.delegate = delegate;
    nwobjOpenShift.date = date;
    [nwobjOpenShift run:self.serverAddress];
}

- (void) repeatPrint:(id<PrinterDelegate>)delegate type:(NSString *)type receiptID:(NSString *)receiptID reqId:(id)reqId
{
    NwobjPrintRepeat *repeatPrint = [NwobjPrintRepeat new];
    repeatPrint.delegate = delegate;
    repeatPrint.reqId = reqId;
    repeatPrint.receiptID = receiptID;
    repeatPrint.receiptType = [type integerValue];
    [repeatPrint run:self.serverAddress];
    
}

- (void) xReport:(id<PrinterDelegate>)delegate
{
    NwobjectXReport *xReport = [NwobjectXReport new];
    xReport.delegate = delegate;
    [xReport run:self.serverAddress];
}

- (void) zReport:(id<PrinterDelegate>)delegate receiptID:(NSString *)receiptID amount:(NSNumber *)amount reqID:(id)reqID
{
    NwobjZreport *zReport = [NwobjZreport new];
    zReport.delegate    = delegate;
    zReport.receiptID   = receiptID;
    zReport.amount      = amount;
    zReport.reqID       = reqID;
    [zReport run:self.serverAddress];
}

- (void) printHistory: (id<PrinterDelegate>)delegate  history:(NSArray*) history
{
    NwobjPrintText *printText = [NwobjPrintText new];
    printText.delegate = delegate;
    printText.operationsHistory = history;
     [printText run:self.serverAddress];
    
}

@end
