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
- (NSUInteger)scanndedCount;
- (NSString *)barcode;

- (void)setScannedCount:(NSUInteger)scannedCount;
@end

@protocol AcceptancesDataSource <NSObject>
- (NSUInteger)numberOfItems;
- (id)itemAtIndex:(NSUInteger)index;
@end
