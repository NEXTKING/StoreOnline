//
//  SettingsViewController+Ostin.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 07/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SettingsViewController+Ostin.h"
#import "AppDelegate.h"

@interface SettingsViewController_Ostin ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SettingsViewController_Ostin

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];
}

- (void)showInfoMessage:(NSString*)info
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:info preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ac dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)logoutButtonPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate resetWindowToInitialView];
}

@end
