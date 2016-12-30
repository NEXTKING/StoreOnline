//
//  ClaimListViewController.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClaimDataSource.h"
#import "ClaimItem.h"

@interface ClaimListViewController : UIViewController
@property (nonatomic, strong) ClaimItem *rootItem;
@end
