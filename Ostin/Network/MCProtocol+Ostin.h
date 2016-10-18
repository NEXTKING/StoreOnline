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

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemID:(NSUInteger)itemID;

- (void) saveTask:(id<TasksDelegate>) delegate taskID:(NSInteger)taskID userID:(NSInteger)userID status:(NSInteger)status date:(NSDate *)date;
- (void) saveTaskItem:(id<TasksDelegate>) delegate taskID:(NSInteger)taskID itemID:(NSInteger)itemID scanned:(NSUInteger)scanned;

@end
