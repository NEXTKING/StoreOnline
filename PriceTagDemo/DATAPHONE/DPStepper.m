//
//  DPStepper.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 10/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "DPStepper.h"
#define DPStepper_BUTTON_SIZE 34

@interface DPStepper()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *increaseButton;
@property (nonatomic, strong) UIButton *desceaseButton;
@end

@implementation DPStepper

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeDefaults];
    [self initializeControls];
}

- (void)initializeDefaults
{
    if (self.minValue == 0 && self.maxValue == 0)
    {
        self.minValue = 0;
        self.maxValue = 100;
    }
    
    if (self.fontSize == 0)
        self.fontSize = 10;
    
    if (self.fontColor == nil)
        self.fontColor = [UIColor blackColor];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)initializeControls
{
    self.label = [UILabel new];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.label];
    self.label.font = [UIFont fontWithName:@"Roboto-Light" size:self.fontSize];
    self.label.textColor = self.fontColor;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self updateLabel];
    
    self.increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.increaseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.increaseButton];
    [self.increaseButton setImage:[UIImage imageNamed:@"plus_ico"] forState:UIControlStateNormal];
    [self.increaseButton addTarget:self action:@selector(increaseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.desceaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.desceaseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.desceaseButton];
    [self.desceaseButton setImage:[UIImage imageNamed:@"minus_ico"] forState:UIControlStateNormal];
    [self.desceaseButton addTarget:self action:@selector(decreaseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.isVertical ? [self initializeVerticalAligment] : [self initializeHorizontalAligment];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    longPress.minimumPressDuration = 1.0;
    [longPress addTarget:self action:@selector(gestureAction:)];
    [self addGestureRecognizer:longPress];
}

- (void)initializeHorizontalAligment
{
    NSDictionary *views = @{@"dButton":self.desceaseButton, @"label":self.label, @"iButton":self.increaseButton};
    NSDictionary *metrics = @{@"buttonSize":@(DPStepper_BUTTON_SIZE), @"m":(_showLabel ? @(2) : @(0))};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[dButton(==buttonSize)]-m-[label]-m-[iButton(==buttonSize)]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dButton(==buttonSize)]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iButton(==buttonSize)]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.desceaseButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.increaseButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)initializeVerticalAligment
{
    NSDictionary *views = @{@"dButton":self.desceaseButton, @"label":self.label, @"iButton":self.increaseButton};
    NSDictionary *metrics = @{@"buttonSize":@(DPStepper_BUTTON_SIZE)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[iButton(==buttonSize)]-0-[label]-0-[dButton(==buttonSize)]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dButton(==buttonSize)]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[iButton(==buttonSize)]" options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.increaseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.desceaseButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

#pragma mark -

- (void)increaseButtonPressed
{
    self.value = (self.value + 1 > self.maxValue) ? self.maxValue : self.value + 1;
    [self updateLabel];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)decreaseButtonPressed
{
    self.value = (self.value - 1 < self.minValue) ? self.minValue : self.value - 1;
    [self updateLabel];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateLabel
{
    self.label.text = self.showLabel ? [NSString stringWithFormat:@"%ld", (long)self.value] : @"";
}

- (void)setValue:(double)value
{
    _value = value;
    [self updateLabel];
}

- (void) gestureAction:(UILongPressGestureRecognizer*) sender
{
    if (sender.state != UIGestureRecognizerStateBegan)
        return;
    
    UIAlertView* bindingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Введите количество", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Отмена", nil) otherButtonTitles:NSLocalizedString(@"Оk", nil), nil];
    bindingAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [bindingAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    bindingAlert.tag = 972;
    [bindingAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 972 && (buttonIndex != alertView.cancelButtonIndex))
    {
        NSInteger alertValue = [[alertView textFieldAtIndex:0].text integerValue];
        
        if (alertValue > self.maxValue)
            self.value = self.maxValue;
        else if (alertValue < self.minValue)
            self.value = self.minValue;
        else
            self.value = alertValue;
        
        [self updateLabel];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
