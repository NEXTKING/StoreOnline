//
//  AntiAliasTextLayer.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 04.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AntiAliasTextLayer.h"

@implementation AntiAliasTextLayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetShouldSmoothFonts( ctx , false );
    CGContextSetAllowsFontSmoothing(ctx, false);
    CGContextSetAllowsAntialiasing( ctx , false );
    CGContextSetShouldAntialias( ctx , false );
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    [super drawInContext:ctx];
}

@end
