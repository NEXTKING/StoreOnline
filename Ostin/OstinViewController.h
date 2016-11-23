//
//  OstinViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 23.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonViewController.h"

@interface OstinViewController : ViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *immediateSwitch;
@property (copy, nonatomic) NSString* externalBarcode;
@property (weak, nonatomic) IBOutlet UILabel *amountStatusLabel;

@end
