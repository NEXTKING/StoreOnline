//
//  LoginViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 19/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "LoginViewController.h"
#import "DTDevices.h"
#import "SynchronizationController.h"
#import "MCPServer.h"

@interface LoginViewController () <DTDeviceDelegate, SyncronizationDelegate, UserDelegate, UITextFieldDelegate>
{
    DTDevices *dtdev;
}
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dtdev = [DTDevices sharedDevice];
    [dtdev addDelegate:self];
    [dtdev connect];
    
    _loginTextField.delegate = self;
    _loginTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _progressView.hidden = YES;
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    [[MCPServer instance] user:self barcode:barcode];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [[MCPServer instance] user:self barcode:barcode];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_loginTextField])
        [_passwordTextField becomeFirstResponder];
    else if ([textField isEqual:_passwordTextField])
    {
        [textField resignFirstResponder];
        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself loginButtonPressed:nil];
        });
    }
    
    return YES;
}

- (IBAction)loginButtonPressed:(id)sender
{
    if (_loginTextField.text != nil && _passwordTextField.text != nil)
    {
        [[MCPServer instance] user:self login:_loginTextField.text password:_passwordTextField.text];
    }
}

- (void)userComplete:(int)result user:(UserInformation *)userInformation
{
    if (result == 0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:userInformation.key_user forKey:@"UserID"];
        [[NSUserDefaults standardUserDefaults] setValue:userInformation.name forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
    }
    else
    {
        [self showAlertWithMessage:@"Введён неверный логин или пароль"];
    }
}

- (void)showAlertWithMessage:(NSString*)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ac dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)sync:(id)sender
{
    [_syncActivity startAnimating];
    _syncButton.enabled = NO;
    _progressView.hidden = NO;
    _resetButton.enabled = NO;
    
    SynchronizationController *sync = [SynchronizationController new];
    sync.delegate = self;
    [sync synchronize];
}

- (IBAction)reset:(id)sender
{
    [_syncActivity startAnimating];
    _syncButton.enabled = NO;
    _resetButton.enabled = NO;
    
    SynchronizationController *sync = [SynchronizationController new];
    sync.delegate = self;
    [sync resetPortions];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [dtdev addDelegate:self];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [dtdev removeDelegate:self];
}

- (void)syncProgressChanged:(double)progress
{
    _progressView.progress = progress;
}

- (void) syncCompleteWithResult:(int)result
{
    _resetButton.enabled = YES;
    _syncButton.enabled = YES;
    _progressView.hidden = YES;
    [_syncActivity stopAnimating];
    
    NSString *message = result == 0 ? @"Синхронизация успешно завершена" : @"Произошла ошибка при синхронизации";
    [self showAlertWithMessage:message];
}

- (void)resetPortionsCompleteWithResult:(int)result
{
    _resetButton.enabled = YES;
    _syncButton.enabled = YES;
    [_syncActivity stopAnimating];
    
    NSString *message = result == 0 ? @"Порции сброшены успешно" : @"Произошла ошибка при сбросе порций";
    [self showAlertWithMessage:message];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
