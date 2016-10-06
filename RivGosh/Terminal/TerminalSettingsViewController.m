//
//  TerminalSettingsViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 02/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "TerminalSettingsViewController.h"
#import "PLManager.h"

@interface TerminalSettingsViewController () <PLManagerDelegate>
{
    PLManager* paymentLibrary;
    UIAlertController* infoAlert;
}
@end

@implementation TerminalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    infoAlert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    paymentLibrary = [PLManager instance];
    paymentLibrary.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showInfoMessage:(NSString*) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
}

- (IBAction)keyExchangeAction:(id)sender
{
    NSError* error = nil;
    [paymentLibrary keyEchange:&error];
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
    }
}

- (IBAction)settingsUpadateAction:(id)sender
{
    NSError* error = nil;
    [paymentLibrary updateTerminalSettings:&error];
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
    }
    
}

#pragma mark - PL Delegate

- (void) paymentManagerWillRequestPINEntry
{
}

- (void) paymentManagerDidReceivePINEntry:(BOOL)success
{
}

- (void) paymentManagerWillRequestCardSwipe
{
}

- (void) paymentManagerDidReceiveCardSwipe
{
}


- (void) paymentManagerWillStartOperation:(PLOperationType)operation
{
    NSString* message = nil;
    
    
    switch (operation) {
        
        case PLOperationTypeSettings:
        {
            message = @"Выполняется проверка соединения с банком...";
        }
            break;
        case PLOperationTypeKeyExchange:
        {
            message = @"Выполняется обмен ключами шифрования...";
        }
            break;
            
        default:
            break;
    }
    
    infoAlert.message = message;
    [self presentViewController:infoAlert animated:YES completion:nil];
}

- (void) paymentManagerDidFinishOperation:(PLOperationType)operation result:(PLOperationResult *)result
{
    
    [infoAlert dismissViewControllerAnimated:YES completion:nil];
    
    NSString*message = @"";
    switch (operation) {
    
        case PLOperationTypeSettings:
        {
            message = (result.success) ? @"Настройки успешно обновлены!":@"Не удалось выполнить обновление настроек. Попробуйте снова.";
        }
            break;
        case PLOperationTypeKeyExchange:
        {
            message = (result.success) ? @"Ключи шифрования успешно загружены!":@"Не удалось получить ключи шифрования. Попробуйте снова.";
        }
            break;
            
        default:
            break;
    }
    
    if (message.length > 0)
        [self showInfoMessage:message];
}


#pragma mark - Table View Delegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* SettingsCellIdentifier = @"SettingsCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SettingsCellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SettingsCellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Обновить настройки";
                break;
            case 1:
                cell.textLabel.text = @"Обмен ключами";
                break;
                
            default:
                break;
                
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                [self settingsUpadateAction:nil];
                break;
            case 1:
                [self keyExchangeAction:nil];
                break;
            case 2:
                break;
                
                
            default:
                break;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        TerminalSettingsViewController *settingsVC = [[TerminalSettingsViewController alloc] init];
        [self.navigationController pushViewController:settingsVC animated:YES];
    }
}

@end
