//
//  ClaimDataSource.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcceptancesProtocol.h"

@interface ClaimDataSource : NSObject <AcceptancesDataSource>

@property (nonatomic, readonly) id<AcceptancesItem> rootItem;
@property (nonatomic, weak) id<AcceptancesDataSourceDelegate> delegate;

- (void)update;
- (void)processItemCode:(NSString *)itemCode;
@end
