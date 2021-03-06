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
#import "AppSuspendingBlocker.h"

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
    AppSuspendingBlocker *_suspendingBlocker;
}
@property (nonatomic, readwrite) BOOL syncIsRunning;
@property (nonatomic, readwrite) double syncProgress;
@end

@implementation SynchronizationController

static void *ProgressObserverContext = &ProgressObserverContext;

+ (instancetype)sharedInstance
{
    static SynchronizationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SynchronizationController alloc] init];
    });
    return sharedInstance;
}

- (void) synchronize
{
    runOnMainThread(^
    {
        if (_progress)
            [_progress removeObserver:self forKeyPath:@"fractionCompleted" context:ProgressObserverContext];
        
        _progress = [NSProgress progressWithTotalUnitCount:5];
        [_progress becomeCurrentWithPendingUnitCount:0];
        [_progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:ProgressObserverContext];
    });
    
    _suspendingBlocker = [AppSuspendingBlocker new];
    [_suspendingBlocker startBlock];
    _syncIsRunning = YES;
    _syncProgress = 0;
    
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
        _syncProgress = progress.fractionCompleted;
        
        if ([_delegate respondsToSelector:@selector(syncProgressChanged:)])
            [_delegate syncProgressChanged:progress.fractionCompleted];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)resetPortions
{
    _syncIsRunning = YES;
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
        [_suspendingBlocker stopBlock];
        runOnMainThread(^
        {
            if ([[NSProgress currentProgress] isEqual:_progress])
                [_progress resignCurrent];
        });
        _syncIsRunning = NO;
        _syncProgress = 0;
        
        if ([_delegate respondsToSelector:@selector(syncCompleteWithResult:)])
            [_delegate syncCompleteWithResult:0];
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
        _syncIsRunning = NO;
        [_suspendingBlocker stopBlock];
        
        if ([_delegate respondsToSelector:@selector(syncCompleteWithResult:)])
            [_delegate syncCompleteWithResult:result];
    }
}

- (void) tasksComplete:(int)result tasks:(NSArray<TaskInformation *> *)tasks
{
    if (result == 0)
    {
        [self updateSyncStatus:SSTasks];
    }
    else
    {
        _syncIsRunning = NO;
        [_suspendingBlocker stopBlock];
        
        if ([_delegate respondsToSelector:@selector(syncCompleteWithResult:)])
            [_delegate syncCompleteWithResult:result];
    }
}

- (void)userComplete:(int)result user:(id)user
{
    if (result == 0)
    {
        [self updateSyncStatus:SSUsers];
    }
    else
    {
        _syncIsRunning = NO;
        [_suspendingBlocker stopBlock];
        
        if ([_delegate respondsToSelector:@selector(syncCompleteWithResult:)])
            [_delegate syncCompleteWithResult:result];
    }
}

- (void)resetDatabaseAndPortionsCountComplete:(int)result
{
    _syncIsRunning = NO;
    
    if ([_delegate respondsToSelector:@selector(resetPortionsCompleteWithResult:)])
        [_delegate resetPortionsCompleteWithResult:result];
}

void runOnMainThread(void (^block)(void))
{
    if ([NSThread isMainThread])
        block();
    else
        dispatch_sync(dispatch_get_main_queue(), block);
}

@end
