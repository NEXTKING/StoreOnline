//
//  SynchronizationController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SynchronizationController.h"
#import "MCPServer.h"

@interface SynchronizationController() <ItemDescriptionDelegate>

@end

@implementation SynchronizationController

- (void) synchronize
{
    [[MCPServer instance] itemDescription:self itemCode:nil shopCode:nil];
}

#pragma mark - Network Delegates

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    
}

- (void) allItemsDescription:(int)result items:(NSArray<ItemInformation *> *)items
{
    if (result == 0)
    {
        if (_delegate)
            [_delegate syncCompleteWithResult:result];
    }
    else
    {
        if (_delegate)
            [_delegate syncCompleteWithResult:result];
    }
}

@end
