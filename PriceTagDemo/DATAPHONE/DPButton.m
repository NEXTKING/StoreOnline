//
//  DPButton.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 12/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "DPButton.h"
#import "AppAppearance.h"

@implementation DPButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 12.0, 0.0, 0.0)];
        [self.titleLabel setFont:AppAppearance.sharedApperance.buttonTitleLabelFont];
        
        [self setTitleColor:AppAppearance.sharedApperance.buttonTitleLabelNormalColor forState:UIControlStateNormal];
        [self setTitleColor:AppAppearance.sharedApperance.buttonTitleLabelHighlightedColor forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    }
    return self;
}


@end
