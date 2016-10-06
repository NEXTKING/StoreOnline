//
//  DetailsTableViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 26.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInformation.h"

@interface DetailsTableViewController : UITableViewController

@property (nonatomic, strong) ItemInformation* item;

@end
