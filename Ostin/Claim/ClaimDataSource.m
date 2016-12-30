//
//  ClaimDataSource.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ClaimDataSource.h"
#import "ClaimItem.h"
#import "ClaimItemInformation.h"
#import "MCPServer.h"
#import "Delegates+Ostin.h"

@interface ClaimDataSource () <ClaimDelegate>
@property (nonatomic, strong) id<AcceptancesItem> rootItem;
@property (nonatomic, strong) NSArray <id<AcceptancesItem>> *items;
@end

@implementation ClaimDataSource

- (instancetype)initWithAcceptanceItem:(id<AcceptancesItem>)acceptancesItem;
{
    self = [super init];
    if (self)
    {
        _rootItem = acceptancesItem;
    }
    return self;
}

- (void)update
{
    if ([_rootItem isKindOfClass:[ClaimItem class]])
    {
        [[MCPServer instance] claim:self claimID:((ClaimItem *)_rootItem).claimID];
    }
    else
    {
        [[MCPServer instance] claim:self claimID:nil];
    }
}

- (NSUInteger)numberOfItems
{
    return _items.count;
}

- (id<AcceptancesItem>)itemAtIndex:(NSUInteger)index
{
    return _items[index];
}

- (void)claimComplete:(int)result items:(NSArray *)items
{
    _items = items;
    [_delegate acceptancesDataSourceDidUpdate];
}

- (void)didScannedBarcode:(NSString *)barcode
{
    for (int i = 0; i < _items.count; i++)
    {
        id<AcceptancesItem> item = _items[i];

        if ([item.barcode isEqualToString:barcode] && [item isKindOfClass:[ClaimItemInformation class]])
        {
            if (item.scannedCount < item.totalCount)
            {
                [item setScannedCount:(item.scannedCount + 1)];
                [_delegate acceptancesDataSourceDidUpdateItemAtIndex:i];
            }
            break;
        }
    }
}

- (void)didInteractWithItemAtIndex:(NSUInteger)index
{
    
}

@end
