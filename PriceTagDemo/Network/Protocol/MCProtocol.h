//
//  MCProtocol.h
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Delegates.h"
#import <CoreLocation/CoreLocation.h>

@protocol MCProtocol <NSObject>

// Session management
@required
- (NSString*)   accessToken;
- (void)        setAccessToken:(NSString*)token;
- (NSString*)   userId;
- (void)        setUserId:(NSString*)token;
- (NSString*)   registerSessionId;
- (void)        setRegisterSessionId:(NSString*)sessionId;

- (int)         lastResult;
- (void)        setLastResult:(int)result;
- (void)        clearSession;
   
// Functions
@required
- (void) hello:(id<HelloDelegate>) delegate;
- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString*) code shopCode:(NSString*) shopCode isoType:(int) type;
- (void) inventoryItemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString*) code;
- (void) authorization:(id<AuthorizationDelegate>)delegate code:(NSString*) code;
- (void) clinetCard:(id<ClientCardDelegate>)delegate cardNumber:(NSString*) card;
- (void) sendCart:(id<SendCartDelegate>)delegate cartData:(NSDictionary*) cartData;
- (void) endOfInvent:(id<SendCartDelegate>)delegate shopID:(NSString*) shopID password:(NSString*)pwd;
- (void) discounts:(id<DiscountsDelegate>)delegate receiptId:(NSString*)receiptID;
- (void) zones:(id<ZonesDelegate>)delegate shopID:(NSString*)shopID;
- (void) stock:(id<StockDelegate>)delegate itemCode:(NSString*) code shopID:(NSString*)shopID;
- (void) acceptanes:(id<AcceptanesDelegate>)delegate shopID:(NSString*)shopID;
- (void) acceptanes:(id<AcceptanesDelegate>)delegate date:(NSDate*)date containerBarcode:(NSString*)containerBarcode;
- (void) addItem:(ItemInformation*)item toAcceptionWithDate:(NSDate*)date containerBarcode:(NSString*)containerBarcode scannedCount:(NSUInteger)scannedCount manually:(BOOL)manually;
- (void) acceptanesHierarchy:(id<AcceptanesDelegate>)delegate date:(NSDate*)date barcode:(NSString*)barcode;
- (void) sendAcceptanes:(id<AcceptanesDelegate>)delegate date:(NSDate *)date shopID:(NSString *)shopID;
@end
