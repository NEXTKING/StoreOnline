//
//  ZReportViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ZReportViewController.h"
#import "MCPServer.h"
#import "PLManager.h"

@interface ZReportViewController () <PrinterDelegate, PLManagerDelegate>
{
    BOOL shouldShowControls;
    BOOL lastRequest;
    ZReport *currentReport;
    UIActivityIndicatorView* loadingActivity;
    UIActivityIndicatorView* zreportActivity;
}

@end

@implementation ZReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self requestData];
    
    zreportActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    zreportActivity.hidesWhenStopped = YES;
    
}

- (void) requestData
{
    
    PLManager* manager = [PLManager instance];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    double amount = [[defaults objectForKey:@"Balance"]doubleValue];
    NSError* error;
    manager.delegate = self;
    [manager reconciliation:amount error:&error];
    
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
        return;
    }
    
    shouldShowControls = NO;
    NSRange sectionsRange = {.location = 0, .length = self.tableView.numberOfSections};
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsRange] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[MCPServer instance] zReport:self receiptID:nil amount:nil reqID:nil];
    loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingActivity.hidesWhenStopped = YES;
    [loadingActivity startAnimating];
    self.tableView.tableFooterView = loadingActivity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!shouldShowControls)
        return 0;
    
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
            
        default:
            break;
    }
    
    return 0;
}


- (void) zReportComplete:(int)result zReport:(ZReport *)report reqID:(id)reqID
{
    [zreportActivity stopAnimating];
    
    if (result == 0)
    {
        if (!lastRequest)
        {
            lastRequest = YES;
            [[MCPServer instance] zReport:self receiptID:report.receiptID amount:nil reqID:nil];
        }
        else
        {
            lastRequest = NO;
            currentReport = report;
            shouldShowControls = YES;
            [loadingActivity stopAnimating];
            
            if (!reqID)
            {
                NSRange sectionsRange = {.location = 0, .length = self.tableView.numberOfSections};
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsRange] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    else
    {
        shouldShowControls = NO;
        lastRequest = NO;
        
        NSString* errorDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkErrorDescription"];
        NSString* message = errorDescription?errorDescription:@"Ошибка снятия Z отчета";
        [self showInfoMessage:message];
    }
}

- (void) showInfoMessage:(NSString*) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Сумма БД";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", currentReport.dbAmount];
                break;
            case 1:
                cell.textLabel.text = @"Сумма ФР";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", currentReport.fiscalAmount];
                break;
            case 2:
                cell.textLabel.text = @"Сумма в банке";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", currentReport.fiscalAmount];
                break;
            case 3:
                cell.textLabel.text = @"Отрицательные остатки";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)currentReport.items.count];
                break;
            default:
                break;
        }
        
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        cell.accessoryView = zreportActivity;
        cell.textLabel.text = @"Снять Z отчет";
    }
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [zreportActivity startAnimating];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        lastRequest = YES;
        [[MCPServer instance] zReport:self receiptID:nil amount:[NSNumber numberWithDouble:currentReport.dbAmount] reqID:[NSNull null]];
    }
}

- (void) paymentManagerDidFinishOperation:(PLOperationType)operation result:(PLOperationResult *)result
{
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
