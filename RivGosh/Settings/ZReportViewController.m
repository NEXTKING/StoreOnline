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
#import "CloseDayOperation.h"
#import "ObtainAmountOperation.h"

@interface ZReportViewController ()
{
    BOOL shouldShowControls;
    BOOL lastRequest;
    ZReport *currentReport;
    NSNumber *bankAmount;
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
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    double amount = [[defaults objectForKey:@"Balance"]doubleValue];
    shouldShowControls = NO;
   
    ObtainAmountOperation *obtainAmount = [ObtainAmountOperation new];
    obtainAmount.terminalAmount = amount;
    __weak ObtainAmountOperation* _obtainAmount = obtainAmount;
    
    NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        BOOL success = _obtainAmount.success;
        bankAmount = _obtainAmount.bankAmount;
        
        if (!success)
            [self showInfoMessage:_obtainAmount.error.localizedDescription];
        else
        {
            shouldShowControls = YES;
            NSRange sectionsRange = {.location = 0, .length = self.tableView.numberOfSections};
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:sectionsRange] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [loadingActivity stopAnimating];
        
    }];
    
    [delegateCallOperation addDependency:obtainAmount];
    
    NSOperationQueue *obtainAmountQueue = [NSOperationQueue new];
    [obtainAmountQueue setMaxConcurrentOperationCount:3];
    obtainAmountQueue.name = @"obtainAmountQueue";
    [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
    [obtainAmountQueue addOperation:obtainAmount];
    
    
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
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", bankAmount.doubleValue/100];
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
        
        
        CloseDayOperation *closeDay = [CloseDayOperation new];
        closeDay.dbAmount = [NSNumber numberWithDouble:currentReport.dbAmount];
        __weak CloseDayOperation *closeDayBlock = closeDay;
       
        NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            BOOL success = closeDayBlock.success;
            
            if (success)
                [self showInfoMessage:@"День успешно закрыт"];
            else
                [self showInfoMessage:closeDayBlock.error.localizedDescription];
            [zreportActivity stopAnimating];
            
        }];
        
        [delegateCallOperation addDependency:closeDay];
        
        NSOperationQueue *closeDayQueue = [NSOperationQueue new];
        [closeDayQueue setMaxConcurrentOperationCount:3];
        closeDayQueue.name = @"closeDayQueue";
        [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
        [closeDayQueue addOperation:closeDay];
        
    }
}



@end
