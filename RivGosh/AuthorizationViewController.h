//
//  AuthorizationViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 25.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *authActivity;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *accessoryToolbar;

@end
