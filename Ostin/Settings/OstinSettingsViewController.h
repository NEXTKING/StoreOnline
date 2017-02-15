//
//  OstinSettingsViewController.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingGroup.h"

@interface OstinSettingsViewController : UIViewController
@property (nonatomic, strong) NSArray<SettingGroup*>*settingsGroups;
@end
