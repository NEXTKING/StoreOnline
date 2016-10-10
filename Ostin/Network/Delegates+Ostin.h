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

@protocol GroupsDelegate <NSObject>
- (void) groupsComplete: (int) result groups:(NSArray*) groups;
- (void) subgroupsComplete: (int) result subgroups:(NSArray*) subgroups;
- (void) brandsComplete: (int) result brands:(NSArray*) brands;
@end

@protocol TasksDelegate <NSObject>
- (void) tasksComplete: (int) result tasks:(NSArray<TaskInformation*>*) tasks;
@end

#endif /* Delegates_Ostin_h */
