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
- (void) search:(id<SearchDelegate>) delegate forQuery:(NSString *)query withAttribute:(ItemSearchAttribute)searchAttribute;

@end
