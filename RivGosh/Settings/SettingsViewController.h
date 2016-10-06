//
//  SettingsViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 24.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *restartActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *xReportButton;
@property (weak, nonatomic) IBOutlet UIButton *zReportButton;

@end
