//
//  SettingsViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTDevices.h"

@interface SettingsViewController : UIViewController
{
    @protected DTDevices *dtdev;
}
@property (weak, nonatomic) IBOutlet UIButton *feedPaperButton;
@property (weak, nonatomic) IBOutlet UIButton *resetBarcodeEngineButton;
@property (weak, nonatomic) IBOutlet UIButton *calibrateBlackMarkButton;
@property (weak, nonatomic) IBOutlet UISwitch *scanSoundSwitch;
@property (weak, nonatomic) IBOutlet UIButton *bindPrinterButton;

@property (nonatomic, copy) void (^feedPaperAction)();
@property (nonatomic, copy) void (^calibrateAction)();
@property (nonatomic, copy) void (^bindPrinterAction)();
@property (nonatomic, copy) void (^temporaryFeedAction)();

@end
