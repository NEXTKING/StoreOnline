//
//  SettingsViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 24.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "RivgoshSettingsViewController.h"
#import "ZReportViewController.h"
#import "MCPServer.h"

@interface SettingsViewController () <PrinterDelegate>

@end

@implementation SettingsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [_zReportButton addTarget:self action:@selector(zReportAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) disableUI:(BOOL) disable
{
    [_restartButton setEnabled:!disable];
    [_xReportButton setEnabled:!disable];
    [_zReportButton setEnabled:!disable];
}

- (IBAction)restartQueueAction:(id)sender
{
    [_restartActivityIndicator startAnimating];
    [self disableUI:YES];
    [[MCPServer instance] restartPrintQueue:self];
}

- (IBAction)xReportAction:(id)sender
{
    [_restartActivityIndicator startAnimating];
    [self disableUI:YES];
    [[MCPServer instance] xReport:self];
}

- (IBAction) zReportAction:(id)sender
{
    ZReportViewController *report = [ZReportViewController new];
    [self.navigationController pushViewController:report animated:YES];
}

- (void) restartPrinterQueueComplete:(int)result
{
    [_restartActivityIndicator stopAnimating];
    [self disableUI:NO];
    
    if (result == 0)
    {
        [self showInfoMessage:@"Очередь перезапущена"];
    }
    else
    {
        [self showInfoMessage:@"Ошибка перезапуска очереди. Попробуйте еще раз"];
    }
}

- (void) xReportComplete:(int)result
{
    [_restartActivityIndicator stopAnimating];
    [self disableUI:NO];
    
    if (result == 0)
    {
    }
    else
    {
        [self showInfoMessage:@"Ошибка печати X-отчета. Попробуйте еще раз"];
    }
}

- (void) showInfoMessage:(NSString*) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
}

@end
