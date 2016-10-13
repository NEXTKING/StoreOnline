//
//  SynchronizationController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SynchronizationController.h"
#import "MCPServer.h"
#import "CoreDataController.h"

typedef enum SyncStages
{
    SSItems = 1 << 0,
    SSTasks = 1 << 1,
    
    SSCount = 1 << 2    //Should be the biggest significant bit
}SyncStages;

@interface SynchronizationController() <ItemDescriptionDelegate, TasksDelegate>
{
    NSInteger updateMask;
}

@end

@implementation SynchronizationController

- (void) synchronize
{
    [[MCPServer instance] itemDescription:self itemCode:nil shopCode:nil isoType:0];
    [[MCPServer instance] tasks:self userID:nil];
    
    NSLog(@"%d", SSCount);
}

#pragma mark - Network Delegates

- (void) updateSyncStatus:(SyncStages) stage
{
    updateMask |= stage;
    BOOL allBitsAreSet = YES;
    NSInteger oneBit = SSCount;
    oneBit >>= 1;
    
    while (oneBit != 0) {
        
        if ((oneBit & updateMask) == 0)
        {
            allBitsAreSet = NO;
            break;
        }
        
        oneBit >>= 1;
    }
    
    if (allBitsAreSet)
        [_delegate syncCompleteWithResult:0];
    
}



- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    NSLog(@"%d", result);
}

- (void) allItemsDescription:(int)result items:(NSArray<ItemInformation *> *)items
{
    
    if (result == 0)
    {
        [self updateSyncStatus:SSItems];
    }
    else
    {
        [_delegate syncCompleteWithResult:result];
    }
}

- (void) tasksComplete:(int)result tasks:(NSArray<TaskInformation *> *)tasks
{
    if (result == 0)
    {
        [self updateSyncStatus:SSTasks];
    }

}

@end
