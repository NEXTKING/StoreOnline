//
//  Delegates+Ostin.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#ifndef Delegates_Ostin_h
#define Delegates_Ostin_h
#import "Delegates.h"
#import "TaskInformation.h"
#import "UserInformation.h"

typedef enum : NSUInteger
{
    ItemSearchAttributeName = (1 << 0),
    ItemSearchAttributeArticle = (1 << 1),
    ItemSearchAttributeItemCode = (1 << 2),
    ItemSearchAttributeBarcode = (1 << 3)
}ItemSearchAttribute;

@protocol ItemDescriptionDelegate_Ostin <ItemDescriptionDelegate>
@property(nonatomic, strong) NSProgress *progress;
- (void) resetDatabaseAndPortionsCountComplete:(int)result;
@end

@protocol GroupsDelegate <NSObject>
- (void) groupsComplete: (int) result groups:(NSArray*) groups;
- (void) subgroupsComplete: (int) result subgroups:(NSArray*) subgroups;
- (void) brandsComplete: (int) result brands:(NSArray*) brands;
@end

@protocol TasksDelegate <NSObject>
@property(nonatomic, strong) NSProgress *progress;
- (void) tasksComplete: (int) result tasks:(NSArray<TaskInformation*>*) tasks;
@end

@protocol SearchDelegate <NSObject>
- (void) searchComplete: (int) result attribute:(ItemSearchAttribute) searchAttribute items:(NSArray *) items;
@end

@protocol UserDelegate <NSObject>
@property(nonatomic, strong) NSProgress *progress;
- (void) userComplete: (int) result user:(UserInformation *)userInformation;
@end

#endif /* Delegates_Ostin_h */
