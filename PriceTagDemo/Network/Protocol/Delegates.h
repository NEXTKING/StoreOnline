//
//  MCProtocol.h
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInformation.h"
#import "DiscountInformation.h"
#import "AcceptanesInformation.h"

@protocol HelloDelegate <NSObject>
- (void) helloComplete:(NSString*)text;
@end
@protocol ItemDescriptionDelegate <NSObject>
- (void) itemDescriptionComplete:(int) result itemDescription:(ItemInformation*) itemDescription;
- (void) allItemsDescription:(int) result items:(NSArray<ItemInformation*>*) items;
@optional
@property NSProgress *progress;
@end

@protocol AuthorizationDelegate <NSObject>
- (void) authorizationComplete:(int) result rights:(NSDictionary*) rights;
@end
@protocol ClientCardDelegate <NSObject>
- (void) clientCardComplete:(int) result description:(NSString*)description hint:(NSString*)hint receiptID:(NSString*) receiptID;
@end
@protocol SendCartDelegate <NSObject>
@optional
- (void) sendCartComplete:(int) result;
- (void) endOfInventComplete:(int) result;
@end
@protocol DiscountsDelegate <NSObject>
- (void) discountsComplete:(int) result discounts:(NSArray<DiscountInformation*>*)discounts;
@end
@protocol ZonesDelegate <NSObject>
- (void) zonesComplete:(int) result zones:(NSArray*)zones;
@optional
@property NSProgress *progress;
@end
@protocol StockDelegate <NSObject>
- (void) stockComplete:(int) result items:(NSArray<ItemInformation*>*) items;
- (void) allStocksComplete:(int) result items:(NSArray<ItemInformation*>*) items;
@end
@protocol AcceptanesDelegate <NSObject>
- (void) acceptanesComplete:(int) result items:(NSArray*)items;
- (void) acceptanesHierarchyComplete:(int)result items:(NSArray<AcceptanesInformation*>*)items;
@optional
@property NSProgress *progress;
- (void) sendAcceptanesComplete:(int)result;
@end


