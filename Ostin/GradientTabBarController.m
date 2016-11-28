//
//  GradientTabBarController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 31/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "GradientTabBarController.h"
#import "DTDevices.h"

@interface GradientTabBarController () <DTDeviceDelegate>

@end

@implementation GradientTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setTranslucent:NO];
    
    DTDevices *dtdev = [DTDevices sharedDevice];
    [self connectionState:dtdev.connstate];
}

- (void)viewWillAppear:(BOOL)animated
{
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev removeDelegate:self];
}

- (void)connectionState:(int)state
{
    switch (state)
    {
        case CONN_CONNECTED:
            [self.tabBar setBackgroundImage:[self imageFromLayer:[self greenLayer]]];
            break;
        case CONN_CONNECTING:
            [self.tabBar setBackgroundImage:[self imageFromLayer:[self redLayer]]];
            break;
        case CONN_DISCONNECTED:
            [self.tabBar setBackgroundImage:[self imageFromLayer:[self redLayer]]];
            break;
        default:
            break;
    }
}

- (CALayer *)greenLayer
{
    CAGradientLayer *layer = [CAGradientLayer new];
    UIColor *color1 = [UIColor colorWithRed:0 green:200/255.0 blue:0 alpha:0.7];
    UIColor *color2 = [UIColor colorWithWhite:1 alpha:0];
    UIColor *color3 = [UIColor colorWithWhite:1 alpha:0];
    
    layer.frame = self.tabBar.frame;
    layer.colors = @[(id)[color1 CGColor], (id)[color2 CGColor], (id)[color3 CGColor]];
    layer.locations = @[@(0), @(0.6), @(1)];
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint = CGPointMake(0, 0);
    
    return layer;
}

- (CALayer *)redLayer
{
    CAGradientLayer *layer = [CAGradientLayer new];
    UIColor *color1 = [UIColor colorWithRed:220/255.0 green:0 blue:0 alpha:0.7];
    UIColor *color2 = [UIColor colorWithWhite:1 alpha:0];
    UIColor *color3 = [UIColor colorWithWhite:1 alpha:0];
    
    layer.frame = self.tabBar.frame;
    layer.colors = @[(id)[color1 CGColor], (id)[color2 CGColor], (id)[color3 CGColor]];
    layer.locations = @[@(0), @(0.6), @(1)];
    layer.startPoint = CGPointMake(0, 1);
    layer.endPoint = CGPointMake(0, 0);
    
    return layer;
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContextWithOptions([layer frame].size, NO, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
