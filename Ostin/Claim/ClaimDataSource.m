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
        
        if ([_rootItem isKindOfClass:[ClaimItem class]])
        {
            
        }
        else
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"SynchronizationControllerDidFinishSync" object:nil];
        }
    }
    return self;
}

- (void)dealloc
{
    if ([_rootItem isKindOfClass:[ClaimItem class]])
    {
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SynchronizationControllerDidFinishSync" object:nil];
    }
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
                
                return;
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(acceptancesDataSourceErrorOccurred:)])
        [_delegate acceptancesDataSourceErrorOccurred:@"Отсканированного товара нет в заявке или его количество превышает нужное"];
}

- (void)processItemCode:(NSString *)itemCode
{
    for (int i = 0; i < _items.count; i++)
    {
        id<AcceptancesItem> item = _items[i];
        
        if ([item isKindOfClass:[ClaimItemInformation class]])
        {
            NSString *_itemCode = [item descriptionForKey:@"articleDescription"];
            if ([[itemCode uppercaseString] isEqualToString:[_itemCode uppercaseString]] && (item.scannedCount < item.totalCount))
            {
                [item setScannedCount:(item.scannedCount + 1)];
                [_delegate acceptancesDataSourceDidUpdateItemAtIndex:i];
                
                return;
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(acceptancesDataSourceErrorOccurred:)])
        [_delegate acceptancesDataSourceErrorOccurred:@"Отсканированного товара нет в заявке или его количество превышает нужное"];
}

- (void)didInteractWithItemAtIndex:(NSUInteger)index
{
    
}

@end
