//
//  CartFooterView.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "CartFooterView.h"

@interface CartFooterView ()
{
    CALayer *TopBorder;
}

@end

@implementation CartFooterView

- (void) awakeFromNib
{
    [super awakeFromNib];

#ifdef MELON
#else
    TopBorder = [CALayer layer];
    TopBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:TopBorder];
#endif
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
