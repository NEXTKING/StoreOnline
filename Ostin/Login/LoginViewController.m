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

@interface LoginViewController () <DTDeviceDelegate, SyncronizationDelegate>
{
    DTDevices *dtdev;
}

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
    [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void) syncCompleteWithResult:(int)result
{
    _syncButton.enabled = YES;
    [_syncActivity stopAnimating];
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
