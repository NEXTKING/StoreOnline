//
//  ItemInfoViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface ItemInfoViewController : ViewController

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *reserveLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashDeskPrice;


@end
