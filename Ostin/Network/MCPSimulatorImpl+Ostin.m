//
//  MCPSimulatorImpl+Ostin.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MCPSimulatorImpl+Ostin.h"
#import "GroupInformation.h"
#import "PI_MOBILE_SERVICEService.h"
#import "NSData+Base64.h"

@interface MCPSimulatorImpl_Ostin ()
{
    NSArray* _groups;
    NSArray* _subgroups;
    NSArray* _brands;;
}

@end

@implementation MCPSimulatorImpl_Ostin

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}


- (void) generateData
{
    [super generateData];
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Обувь";
        [groups addObject:group];
    }
    
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Одежда";
        [groups addObject:group];
    }
    
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Аксессуары";
        [groups addObject:group];
    }
    
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Инвентарь";
        [groups addObject:group];
    }
    
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Прочее";
        [groups addObject:group];
    }
    
    _groups = groups;
    
    
    NSMutableArray* subgroups = [NSMutableArray new];
    
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Куртки";
        [subgroups addObject:group];
    }
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Дождевики";
        [subgroups addObject:group];
    }
    {
        GroupInformation* group = [GroupInformation new];
        group.groupId = @"1";
        group.groupName = @"Плащи";
        [subgroups addObject:group];
    }
    
    _subgroups = subgroups;
}

- (void) groups:(id<GroupsDelegate>)delegate uid:(NSString *)uid
{
    if (delegate)
        [delegate groupsComplete:0 groups:_groups];
}

- (void) subgroups:(id<GroupsDelegate>)delegate uid:(NSString *)uid
{
    if (delegate)
        [delegate subgroupsComplete:0 subgroups:_subgroups];
}

- (void) brands:(id<GroupsDelegate>)delegate uid:(NSString *)uid
{
    
}

- (void) tasks:(id<TasksDelegate>)delegate userID:(NSNumber *)userID
{
    [delegate tasksComplete:0 tasks:nil];
}


@end
