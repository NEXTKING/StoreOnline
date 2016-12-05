//
//  SettingsSwitchCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 05/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@end
