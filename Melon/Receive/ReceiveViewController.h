//
//  ReceiveViewController.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptanesInformation.h"

@interface ReceiveViewController : UIViewController
@property (nonatomic, strong) AcceptanesInformation *rootItem;
@property (nonatomic, strong) NSDate *date;
@end
