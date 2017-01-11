//
//  MenuViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lastSyncLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSyncDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@end
