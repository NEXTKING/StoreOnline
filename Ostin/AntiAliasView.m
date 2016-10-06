//
//  AntiAliasView.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 04.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AntiAliasView.h"

@implementation AntiAliasView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState( context );
    CGContextSetShouldSmoothFonts( context , false );
    CGContextSetAllowsFontSmoothing(context, false);
    CGContextSetAllowsAntialiasing( context , false );
    CGContextSetShouldAntialias( context , false );
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [super drawRect:rect];
    [_image drawInRect:rect];
    CGContextRestoreGState( context );
}


@end
