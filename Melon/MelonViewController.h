//
//  MelonViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 4/29/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ViewController.h"

@interface MelonViewController : ViewController

@property (weak, nonatomic) IBOutlet UISwitch *barcodeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *copiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *revaluationLabel;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;

@end
