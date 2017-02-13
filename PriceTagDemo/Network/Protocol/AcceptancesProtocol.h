//
//  AcceptancesProtocol.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AcceptancesItem <NSObject>
- (NSUInteger)totalCount;
- (NSUInteger)scannedCount;
- (NSString *)barcode;
- (NSString *)descriptionForKey:(NSString *)key;
- (void)setScannedCount:(NSUInteger)scannedCount;
- (void)setCancelReason:(NSString *)cancelReason;
@end

@protocol AcceptancesDataSource <NSObject>
- (instancetype)initWithAcceptanceItem:(id<AcceptancesItem>)acceptancesItem;
- (NSUInteger)numberOfItems;
- (id<AcceptancesItem>)itemAtIndex:(NSUInteger)index;
- (void)didScannedBarcode:(NSString *)barcode type:(int)type;
- (void)didInteractWithItemAtIndex:(NSUInteger)index;
@end

@protocol AcceptancesDataSourceDelegate <NSObject>
- (void)acceptancesDataSourceDidUpdate;
- (void)acceptancesDataSourceDidUpdateItemAtIndex:(NSUInteger)index;
@optional
- (void)acceptancesDataSourceErrorOccurred:(NSString *)errorMessage;
@end
