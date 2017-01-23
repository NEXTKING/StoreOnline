//
//  DPSwitch.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 17/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "DPSwitch.h"

@implementation DPSwitch

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.onTintColor = [UIColor colorWithRed:0 green:153.0/255.0 blue:240.0/255.0 alpha:1];
    self.tintColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1];
    self.layer.cornerRadius = 16.0;
    self.transform = CGAffineTransformMakeScale(0.85, 0.85);
}

@end
