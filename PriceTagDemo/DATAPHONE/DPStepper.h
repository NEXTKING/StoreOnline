//
//  DPStepper.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 10/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPStepper : UIControl
@property (nonatomic, assign) IBInspectable double value;
@property (nonatomic, assign) IBInspectable NSInteger minValue;
@property (nonatomic, assign) IBInspectable NSInteger maxValue;
@property (nonatomic, assign) IBInspectable BOOL showLabel;
@property (nonatomic, assign) IBInspectable CGFloat fontSize;
@property (nonatomic, assign) IBInspectable UIColor *fontColor;
@property (nonatomic, assign) IBInspectable BOOL isVertical;
@end
