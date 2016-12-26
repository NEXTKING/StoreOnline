//
//  TerminalViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 30/08/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "TerminalViewController.h"
#import "PLManager.h"
#import "TerminalSettingsViewController.h"
#import "MCPServer.h"

@interface TerminalViewController () <PLManagerDelegate, UITableViewDelegate, UITableViewDataSource, PrinterDelegate>
{
    UIAlertController* infoAlert;
    PLManager *paymentLibrary;
}

@end

@implementation TerminalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    infoAlert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    paymentLibrary = [PLManager instance];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    paymentLibrary.delegate = self;
    // Unselect the selected row if any
    NSIndexPath*    selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOnAction:(id)sender
{
    NSError* error = nil;
    [paymentLibrary signOn:&error];
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
    }
}

- (IBAction)historyAction:(id) sender
{
    NSError* error = nil;
    [paymentLibrary operationsHistory:&error];
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
    }
   
    /*NSMutableArray* ops = [[NSMutableArray alloc] init];
    {
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }
    {
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }
    {
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }
    {
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }
    {
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }
    {
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }
    {
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }{
        NSArray* op = @[@(200), @"123123123",@"123123123",@"123456789",@"123123123",@"123123123",@(123.45)];
        [ops addObject:op];
    }
        
    [[MCPServer instance] printHistory:self history:ops];*/
}

- (IBAction)reversalAction:(id)sender
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString*lastRRN =  [defaults objectForKey:@"lastReferenceNumber"];
    NSString*lastAmount =  [defaults objectForKey:@"lastAmount"];
    
    if (!lastRRN || !lastAmount)
    {
        [self showInfoMessage:@"Нет данных по последней транзакции."];
        return;
    }
    
    NSError* error = nil;
    [paymentLibrary reversal:lastAmount.doubleValue referenceNumber:lastRRN error:&error];
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
    }
}

- (void) showInfoMessage:(NSString*) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
}

#pragma mark - Payment Library Delegate

- (void) paymentManagerWillRequestPINEntry
{
    infoAlert.message = @"Введите ПИН на клавиатуре терминала";
    if (self.presentedViewController != infoAlert)
        [self presentViewController:infoAlert animated:YES completion:nil];
}

- (void) paymentManagerDidReceivePINEntry:(BOOL)success
{
    if (success)
    {
    }
    else
    {
        [self showInfoMessage:@"Ошибка ввода ПИН кода"];
    }
}

- (void) paymentManagerWillRequestCardSwipe
{
    infoAlert.message = @"Вставьте карту оплаты или приложите ее к считывателю";
    [self presentViewController:infoAlert animated:YES completion:nil];
}

- (void) paymentManagerDidReceiveCardSwipe
{
}

- (void) paymentManagerWillStartOperation:(PLOperationType)operation
{
    NSString* message = nil;
    
    
    switch (operation) {
        case PLOperationTypeReversal:
        {
            message = @"Выполняется отмена последней операции...";
        }
            break;
        case PLOperationTypeSignOn:
        {
            message = @"Выполняется обновление настроек...";
        }
            break;
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
        case PLOperationTypeHistory:
        {
            message = @"Получение истории операций...";
        }
            break;
            
        default:
            break;
    }
    
    infoAlert.message = message;
    if (self.presentedViewController != infoAlert)
        [self presentViewController:infoAlert animated:YES completion:nil];
}

- (void) paymentManagerDidFinishOperation:(PLOperationType)operation result:(PLOperationResult *)result
{
   
    if (operation != PLOperationTypeHistory)
        [infoAlert dismissViewControllerAnimated:YES completion:nil];
    
    NSString*message = @"";
    switch (operation) {
        case PLOperationTypeReversal:
        {
            message = (result.success) ? @"Последняя транзакция успешно отменена!":@"Не удалось выполнить отмену последней транзакции. Попробуйте снова.";
        }
            break;
        case PLOperationTypeSignOn:
        {
            message = (result.success) ? @"Соединение с банком успешно установлено!":@"Не удалось установить соединение с банком. Попробуйте снова.";
        }
            break;
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
        case PLOperationTypeHistory:
        {
            if (result.success && result.operationsHistory.count > 0)
            {
                infoAlert.message = @"Печать истории операций...";
                [[MCPServer instance] printHistory:self history:result.operationsHistory];
            }
            else if (result.success && result.operationsHistory.count == 0)
            {
                 message = @"История не содержит ни одной операции.";
                [infoAlert dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                message = @"Не удалось получить историю операций. Попробуйте снова.";
                [infoAlert dismissViewControllerAnimated:YES completion:nil];
            }
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
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    
    return 0;
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
                cell.textLabel.text = @"Проверка связи";
                break;
            case 1:
                cell.textLabel.text = @"Отмена последней транзакции";
                break;
            case 2:
                cell.textLabel.text = @"Сверка итогов";
                break;
            case 3:
                cell.textLabel.text = @"История операций";
                break;
                
            default:
                break;
                
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    else{
        cell.textLabel.text = @"Настройки терминала";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                [self signOnAction:nil];
                break;
            case 1:
                [self reversalAction:nil];
                break;
            case 2:
                break;
            case 3:
                [self historyAction:nil];
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


- (void) printTextComplete:(int)result
{
    [infoAlert dismissViewControllerAnimated:YES completion:nil];
    
    if (result == 0)
    {
        [self showInfoMessage:@"История успешно напечатана!"];
    }
    else
    {
        [self showInfoMessage:@"Ошибка печати истории. Попробуйте снова."];
    }
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
