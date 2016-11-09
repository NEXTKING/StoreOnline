//
//  Delegates+RivGosh.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 23.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#ifndef Delegates_RivGosh_h
#define Delegates_RivGosh_h

#import "Delegates.h"
#import "PrinterStatus.h"
#import "ZReport.h"

#endif /* Delegates_RivGosh_h */

@protocol ApplyDiscountsDelegate <NSObject>
- (void) applyDiscountsComplete:(int)result items:(NSArray*) items;
@end

@protocol PrinterDelegate <NSObject>
@optional
- (void) printRepeatComplete:(int) result reqID:(id) reqID;
- (void) printStatusComplete:(int) result detailedDescription:(PrinterStatus*) status;
- (void) restartPrinterQueueComplete:(int) result;
- (void) openShiftComplete: (int) result;
- (void) xReportComplete:   (int) result;
- (void) zReportComplete:   (int) result zReport:(ZReport*)report reqID:(id)reqID;
- (void) printTextComplete: (int) result;
@end

@protocol SendPaymentDelegate <NSObject>
- (void) sendPaymentComplete:(int) result;
- (void) sendLoyaltyComplete:(int) result;
@end
