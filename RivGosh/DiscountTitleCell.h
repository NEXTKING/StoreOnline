//
//  DiscountTitleCell.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 27.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end
