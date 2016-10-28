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

@interface LoginViewController () <DTDeviceDelegate, SyncronizationDelegate, UserDelegate>
{
    DTDevices *dtdev;
}
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dtdev = [DTDevices sharedDevice];
    [dtdev addDelegate:self];
    [dtdev connect];
    
    // Do any additional setup after loading the view.
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    [[MCPServer instance] user:self barcode:barcode];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [[MCPServer instance] user:self barcode:barcode];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        #warning Incorrect userID
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"UserID"];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)sync:(id)sender
{
    [_syncActivity startAnimating];
    _syncButton.enabled = NO;
    
    SynchronizationController *sync = [SynchronizationController new];
    sync.delegate = self;
    [sync synchronize];
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

- (void) syncCompleteWithResult:(int)result
{
    _syncButton.enabled = YES;
    [_syncActivity stopAnimating];
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
