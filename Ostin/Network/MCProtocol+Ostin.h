//
//  MCProtocol+Ostin.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#ifndef MCProtocol_Ostin_h
#define MCProtocol_Ostin_h
#import "Delegates+Ostin.h"
#import "MCProtocol.h"

#endif /* MCProtocol_Ostin_h */

@protocol MCProtocolOstin <MCProtocol>

- (void) resetDatabaseAndPortionsCount:(id<ItemDescriptionDelegate_Ostin>)delegate;
- (void) groups:(id<GroupsDelegate>) delegate uid:(NSString*)uid;
- (void) subgroups:(id<GroupsDelegate>) delegate uid:(NSString*)uid;
- (void) brands:(id<GroupsDelegate>) delegate uid:(NSString*)uid;
- (void) tasks:(id<TasksDelegate>) delegate userID:(NSString*) userID;
- (void) tasks:(id<TasksDelegate>) delegate taskID:(NSNumber*) taskID;
- (void) search:(id<SearchDelegate>) delegate forQuery:(NSString *)query withAttribute:(ItemSearchAttribute)searchAttribute;
- (void) user:(id<UserDelegate>)delegate login:(NSString *)login password:(NSString *)password;
- (void) user:(id<UserDelegate>)delegate barcode:(NSString *)barcode;
- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemID:(NSUInteger)itemID;
- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate article:(NSString *)article;
- (void) itemsDescription:(id<ItemDescriptionDelegate>)delegate itemIDs:(NSArray<NSNumber *>*)itemIDs;
- (void) itemDescriptionWithItemCode:(NSString *)code isoType:(int)type completion:(void (^)(BOOL success, ItemInformation *item))completion;

- (void) saveTaskWithID:(NSInteger)taskID userID:(NSString *)userID status:(NSInteger)status date:(NSDate *)date completion:(void (^)(BOOL success, NSString *errorMessage))completion;
- (void) saveTaskItem:(id<TasksDelegate>) delegate taskID:(NSInteger)taskID itemID:(NSInteger)itemID scanned:(NSUInteger)scanned;
- (void) savePrintItemsCount:(NSInteger)count inTaskWithID:(NSInteger)taskID;
- (void) savePrintItemFactForItemCode:(NSString *)itemCode taskName:(NSString *)taskName;

@end
