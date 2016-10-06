//
//  CommonConfirmButton.m
//  Checklines
//
//  Created by Denis Kurochkin on 13.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "CommonConfirmButton.h"

@interface CommonConfirmButton()
@property (nonatomic, copy) UIColor *currentColor;

@end

@implementation CommonConfirmButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) dealloc
{
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderWidth = 1.0;
    self.currentColor = self.backgroundColor;
    
    self.backgroundColor = [UIColor clearColor];
    const CGFloat* colors = CGColorGetComponents( _currentColor.CGColor );
    CGFloat red = colors[0];
    CGFloat green = colors[1];
    CGFloat blue = colors[2];
    [self setTitleColor:_currentColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.3] forState:UIControlStateDisabled];
    self.layer.cornerRadius = 8.0;
    
    
    //[self setButtonColor];
    [self setEnabled:self.enabled];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    const CGFloat* colors = CGColorGetComponents( _currentColor.CGColor );
    CGFloat red = colors[0];
    CGFloat green = colors[1];
    CGFloat blue = colors[2];
    
    if (highlighted)
    {
        self.layer.borderColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5].CGColor;
    }
    else
    {
        self.layer.borderColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    }
}

- (void) setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    const CGFloat* colors = CGColorGetComponents( _currentColor.CGColor );
    CGFloat red = colors[0];
    CGFloat green = colors[1];
    CGFloat blue = colors[2];
    
    if (!enabled)
    {
        self.layer.borderColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.3].CGColor;
    }
    else
    {
        self.layer.borderColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds
                                cornerRadius:3.0] addClip];
    // Draw your image
    [image drawInRect:self.bounds];
    
    // Get the image, here setting the UIImageView image
    UIImage *toReturn = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return toReturn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
