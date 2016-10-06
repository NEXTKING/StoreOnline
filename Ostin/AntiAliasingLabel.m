//
//  AntiAliasingLabel.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 04.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AntiAliasingLabel.h"

@implementation AntiAliasingLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) drawRect:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState( context );
    CGContextSetShouldSmoothFonts( context , false );
    CGContextSetAllowsFontSmoothing(context, false);
    CGContextSetAllowsAntialiasing( context , false );
    CGContextSetShouldAntialias( context , false );
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [super drawRect:r];
    CGContextRestoreGState( context );
}

@end
