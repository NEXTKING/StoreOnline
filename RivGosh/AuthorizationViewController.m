//
//  AuthorizationViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 25.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "MCPServer.h"
#import "DTDevices.h"
#import "AboutLoginViewController.h"

@interface AuthorizationViewController () <AuthorizationDelegate, UITextFieldDelegate>
{
    BOOL authInProgress;
}

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice addDelegate:self];
    
    NSError *error = nil;
    [dtDevice connect];
    
    NSLog(@"Error descripion: %@", error.localizedDescription);
    //NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    //_buildLabel.text = [NSString stringWithFormat:@"Build: %@", build];
    _buildLabel.text = @"";
    // Do any additional setup after loading the view.
    
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.inputAccessoryView = _accessoryToolbar;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self action:@selector(showAppInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = infoButton;
    
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _statusView.layer.cornerRadius = _statusView.frame.size.height/2;
}

- (void) showAppInfo
{
    AboutLoginViewController* about = [[AboutLoginViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:about animated:YES];
}

- (void) connectionState:(int)state
{
    switch (state) {
        case CONN_CONNECTED:
        {
            _statusView.backgroundColor = [UIColor greenColor];
            
            DTDevices *dtDevice = [DTDevices sharedDevice];
            //_stateLabel.text = [NSString stringWithFormat:@"Case connected: %@", dtDevice.deviceName];
            [dtDevice emsrConfigMaskedDataShowExpiration:TRUE showServiceCode:TRUE showTrack3:FALSE unmaskedDigitsAtStart:6 unmaskedDigitsAtEnd:2 unmaskedDigitsAfter:7 error:nil];
            [dtDevice emsrSetEncryption:7 keyID:2 params:nil error:nil];
            
            //[dtDevice emsrConfigMaskedDataShowExpiration:TRUE showServiceCode:TRUE showTrack3:FALSE unmaskedDigitsAtStart:6 unmaskedDigitsAtEnd:2 unmaskedDigitsAfter:7 error:nil];
            //[dtDevice emsrSetEncryption:7 keyID:2 params:nil error:nil];
            //[printVC startSearchingPtinter];
            
        }
            break;
        case CONN_CONNECTING:
            //_stateLabel.text = @"No case connected";
            _statusView.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
        case CONN_DISCONNECTED:
            //_stateLabel.text = @"No case connected";
            _statusView.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice removeDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice addDelegate:self];
    
    _passwordTextField.text = @"";
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [self performAuthWithCode:barcode];
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    [self performAuthWithCode:barcode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) performAuthWithCode:(NSString*) code
{
    if (authInProgress)
        return;
    
    authInProgress = YES;
    [_authActivity startAnimating];
    [[MCPServer instance] authorization:self code:code];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) authorizationComplete:(int)result rights:(NSDictionary *)rights
{
    authInProgress = NO;
    
    [_authActivity stopAnimating];
    if (result == 0)
    {
        [self performSegueWithIdentifier:@"AuthorizationSegue" sender:nil];
    }
    else if (result == 403)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Пользователь не найден в базе" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else if (result == 400)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Устройство не зарегестрировано в системе" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"При авторизации произошла ошибка" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [self performAuthWithCode:textField.text];
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

@end
