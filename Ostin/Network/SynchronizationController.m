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
    SSUsers = 1 << 2,
    
    SSCount = 1 << 3    //Should be the biggest significant bit
}SyncStages;

@interface SynchronizationController() <ItemDescriptionDelegate_Ostin, TasksDelegate, UserDelegate>
{
    NSInteger updateMask;
    NSProgress *_progress;
}
@end

@implementation SynchronizationController

static void *ProgressObserverContext = &ProgressObserverContext;

- (void) synchronize
{
    _progress = [NSProgress progressWithTotalUnitCount:5];
    [_progress becomeCurrentWithPendingUnitCount:0];
    [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:ProgressObserverContext];
    
    [[MCPServer instance] itemDescription:self itemCode:nil shopCode:nil isoType:0];
    [[MCPServer instance] tasks:self userID:nil];
    [[MCPServer instance] user:self login:nil password:nil];
    
    NSLog(@"%d", SSCount);
}

// avoid warning

- (void)setProgress:(NSProgress *)progress
{
    
}

- (NSProgress *)progress
{
    return _progress;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ProgressObserverContext)
    {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"TOTAL PROGRESS IS: %f", progress.fractionCompleted);
        [_delegate syncProgressChanged:progress.fractionCompleted];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)resetPortions
{
    [[MCPServer instance] resetDatabaseAndPortionsCount:self];
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
    {
        [_progress resignCurrent];
        [_delegate syncCompleteWithResult:0];
        [_progress removeObserver:self forKeyPath:@"fractionCompleted" context:ProgressObserverContext];
    }
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

- (void)userComplete:(int)result user:(id)user
{
    if (result == 0)
    {
        [self updateSyncStatus:SSUsers];
    }
}

- (void)resetDatabaseAndPortionsCountComplete:(int)result
{
    [_delegate resetPortionsCompleteWithResult:result];
}

@end
