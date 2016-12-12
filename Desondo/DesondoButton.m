//
//  DesondoButton.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "DesondoButton.h"

@implementation DesondoButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void) setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted)
    {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.alpha = enabled ? 1.0:0.3;
}

@end
