//
//  UIStepperManual.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 12/07/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "UIStepperManual.h"

@interface UIStepperManual () <UIAlertViewDelegate>

@end

@implementation UIStepperManual 

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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    longPress.minimumPressDuration = 1.0;
    [longPress addTarget:self action:@selector(gestureAction:)];
    [self addGestureRecognizer:longPress];
}

- (void) gestureAction:(UILongPressGestureRecognizer*) sender
{
    if (sender.state != UIGestureRecognizerStateBegan)
        return;
    
    UIAlertView* bindingAlert = [[UIAlertView alloc] initWithTitle:@"Введите количество" message:nil delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Оk", nil];
    bindingAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[bindingAlert textFieldAtIndex:0].text = [NSString stringWithFormat:@"%.0f", self.value];
    [bindingAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    bindingAlert.tag = 986;
    [bindingAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        self.value = [[alertView textFieldAtIndex:0].text integerValue];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
