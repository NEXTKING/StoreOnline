//
//  StockViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 30/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "StockViewController.h"
#import "MCPServer.h"
#import "DTDevices.h"
#import "StockCell.h"

@interface StockViewController () <StockDelegate, DTDeviceDelegate>
{
    NSArray* stocks;
    DTDevices* dtDev;
}

@end

@implementation StockViewController

static NSString * const reuseIdentifier = @"StockCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dtDev = [DTDevices sharedDevice];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StockCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [dtDev addDelegate:self];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [dtDev removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)manualInputAction:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Ручной ввод", nil)
                                                                   message:NSLocalizedString(@"Введите штрих-код", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отправить", nil) style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [self barcodeData:alert.textFields[0].text type:0];
                                                          }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField* textField)
     {
         textField.keyboardType = UIKeyboardTypeNumberPad;
     }];
    
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
    [alert show];
}

#pragma mark - DTDevices Delegate

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    [[MCPServer instance] stock:self itemCode:barcode shopID:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return stocks.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ItemInformation* item = stocks[indexPath.row];
    
    cell.nameLabel.text     = item.name;
    cell.articleLabel.text  = item.article;
    cell.stockLabel.text    = [NSString stringWithFormat:@"%ld", (long)item.stock];
    
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    //if ( tableView.numberOfSections > 0 && [tableView numberOfRowsInSection:0] == 0)
    //    return @"Отсканируйте штрих-код товара";
    if (stocks.count < 1)
        return NSLocalizedString(@"Отсканируйте штрих-код товара", nil);
    
    return nil;
}

#pragma mark - Network Delegate

- (void) stockComplete:(int)result items:(NSArray<ItemInformation *> *)items
{
    if (result == 0)
    {
        stocks = items;
    }
    else
    {
        stocks = nil;
        [self showInfoMessage:NSLocalizedString(@"Не удалось найти товар в базе", nil)];
    }
    
    [self.tableView reloadData];
}

- (void) allStocksComplete:(int)result items:(NSArray<ItemInformation *> *)items
{
    
}


@end
