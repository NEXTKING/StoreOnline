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

- (void) groups:(id<GroupsDelegate>) delegate uid:(NSString*)uid;
- (void) subgroups:(id<GroupsDelegate>) delegate uid:(NSString*)uid;
- (void) brands:(id<GroupsDelegate>) delegate uid:(NSString*)uid;
- (void) tasks:(id<TasksDelegate>) delegate userID:(NSNumber*) userID;
- (void) tasks:(id<TasksDelegate>) delegate taskID:(NSNumber*) taskID;
- (void) search:(id<SearchDelegate>) delegate forQuery:(NSString *)query withAttribute:(ItemSearchAttribute)searchAttribute;
- (void) user:(id<UserDelegate>)delegate login:(NSString *)login password:(NSString *)password;
- (void) user:(id<UserDelegate>)delegate barcode:(NSString *)barcode;
- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemID:(NSUInteger)itemID;
- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate article:(NSString *)article;

- (void) saveTaskWithID:(NSInteger)taskID userID:(NSInteger)userID status:(NSInteger)status date:(NSDate *)date completion:(void (^)(BOOL success, NSString *errorMessage))completion;
- (void) saveTaskItem:(id<TasksDelegate>) delegate taskID:(NSInteger)taskID itemID:(NSInteger)itemID scanned:(NSUInteger)scanned;

@end
