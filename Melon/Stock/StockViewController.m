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
#import "AppAppearance.h"
#import "StockGroup.h"
#import "StockDetailsViewController.h"

@interface StockViewController () <StockDelegate, DTDeviceDelegate>
{
    NSArray<StockGroup*>* stocks;
    DTDevices* dtDev;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *shieldView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@end

@implementation StockViewController

static NSString * const reuseIdentifier = @"StockCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Остатки товара", nil);
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:AppAppearance.sharedApperance.navigationBarManualInputImage style:UIBarButtonItemStylePlain target:self action:@selector(manualInputAction:)];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    self.tableView.separatorColor = AppAppearance.sharedApperance.tableViewSeparatorColor;
    self.tableView.separatorStyle = AppAppearance.sharedApperance.tableViewSeparatorStyle;
    self.tableView.separatorInset = AppAppearance.sharedApperance.tableViewSeparatorInsets;
    self.tableView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    _shieldView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    
    _placeholderLabel.text = NSLocalizedString(@"Отсканируйте штрих-код товара", nil);
    _placeholderLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Font;
    
    dtDev = [DTDevices sharedDevice];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StockCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
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
    
    StockGroup* group = stocks[indexPath.row];
    
    cell.nameLabel.text     = group.title;
    cell.articleLabel.text  = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Арт.", nil), group.article];
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    NSArray *sizes = [group sizes];
    NSMutableString *stockDescription = [NSMutableString new];
    NSMutableString *sizesDescription = [NSMutableString new];
    for (int i = 0; i < sizes.count; i++)
    {
        NSString *size = sizes[i];
        [stockDescription appendFormat:@"%ld%@", [group countForSize:size color:nil], (i == sizes.count - 1 ? @"" : @"\n")];
        [sizesDescription appendFormat:@"%@%@", size, (i == sizes.count - 1 ? @"" : @"\n")];
    }
    
    cell.sizesLabel.text = sizesDescription;
    cell.stocksLabel.text = stockDescription;
    cell.totalCountLabel.text = [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Итого", nil), [group totalCount]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"StockDetailsSegue" sender:indexPath];
}

#pragma mark - Network Delegate

- (void) stockComplete:(int)result items:(NSArray<ItemInformation *> *)items
{
    if (result == 0)
    {
        StockGroup *group = [[StockGroup alloc] initWithItems:items];
        stocks = @[group];
    }
    else
    {
        stocks = nil;
        [self showInfoMessage:NSLocalizedString(@"Не удалось найти товар в базе", nil)];
    }
    
    if (stocks.count > 0)
    {
        _shieldView.hidden = YES;
        _tableView.scrollEnabled = YES;
    }
    else
    {
        _shieldView.hidden = NO;
        _tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void) allStocksComplete:(int)result items:(NSArray<ItemInformation *> *)items
{
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StockDetailsSegue"])
    {
        StockDetailsViewController *dvc = segue.destinationViewController;
        NSIndexPath *indexPath = sender;
        dvc.group = stocks[indexPath.row];
    }
}

@end
