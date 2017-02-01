//
//  InventoryViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 28.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "InventoryViewController.h"
#import "MCPServer.h"
#import "CartCell.h"
#import "AppAppearance.h"

@interface InventoryViewController () <UIAlertViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation InventoryViewController

- (void)viewDidLoad
{
    // [super viewDidLoad];
    self.title = NSLocalizedString(@"Инвентаризация", nil);
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:AppAppearance.sharedApperance.navigationBarManualInputImage style:UIBarButtonItemStylePlain target:self action:@selector(manualInputAction:)];
    self.navigationItem.rightBarButtonItem = sendButton;
    
    self.tableView.separatorColor = AppAppearance.sharedApperance.tableViewSeparatorColor;
    self.tableView.separatorStyle = AppAppearance.sharedApperance.tableViewSeparatorStyle;
    self.tableView.separatorInset = AppAppearance.sharedApperance.tableViewSeparatorInsets;
    self.tableView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    _shieldView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    self.cartHeader.backgroundColor = AppAppearance.sharedApperance.tableViewSectionHeaderBackgroundColor;
    self.sectionLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Font;
    self.sectionLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Color;
    self.countLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle2Font;
    self.countLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle2Color;
    self.countTitleLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle3Font;
    self.countTitleLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle3Color;
    
    _sectionLabel.text = _section.name;//[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Зона", nil), _section.name];
    _countTitleLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Количество", nil)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* inventoryCache = [defaults objectForKey:@"inventoryCache"];
    
    if (inventoryCache)
    {
        NSArray *currentSectionCache = [inventoryCache objectForKey:_section.barcode];
        if (currentSectionCache.count > 0)
        {
            for (NSDictionary* dictItem in currentSectionCache) {
                NSData* encodedItemInfo = [dictItem objectForKey:@"object"];
                ItemInformation* itemInfo = (ItemInformation*)[NSKeyedUnarchiver unarchiveObjectWithData:encodedItemInfo];
                NSNumber* quantity        = [dictItem objectForKey:@"quantity"];
                
                if (itemInfo)
                {
                    [self.items addObject:itemInfo];
                    [self.itemsCount setObject:quantity forKey:itemInfo.barcode];
                }
            }
            
            [self.tableView reloadData];
            self.tableView.scrollEnabled = YES;
            _shieldView.hidden = YES;
            [self updateTotalQuantity];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Внимание", nil) message:NSLocalizedString(@"Продолжить существующий список?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Очистить", nil) otherButtonTitles:NSLocalizedString(@"Продолжить", nil), nil];
            alert.tag = 10;
            [alert show];
        }
    }
    
    self.navigationItem.hidesBackButton = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(save)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];
    
   /* NSDictionary* params = @{@"barcode":@"123",@"type":@(0)};
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"BarcodeScanNotification"
     object:params];*/
    
    _placeholderLabel.text = NSLocalizedString(@"Отсканируйте штрих-код товара", nil);
    _placeholderLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Font;
}

- (void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* inventoryCache = [[defaults objectForKey:@"inventoryCache"] mutableCopy];
    if (!inventoryCache)
        inventoryCache = [NSMutableDictionary new];
    
    if (self.items.count < 1)
    {
        [inventoryCache removeObjectForKey:_section.barcode];
        [defaults setObject:inventoryCache forKey:@"inventoryCache"];
        [defaults synchronize];
        return;
    }
    
    NSMutableArray* currentSectionCache = [NSMutableArray new];
    for (ItemInformation* itemInfo in self.items) {
        
        NSData *itemEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:itemInfo];
        NSNumber *quantity = [self.itemsCount objectForKey:itemInfo.barcode];
        NSDictionary *dictItem = @{@"object":itemEncodedObject, @"quantity":quantity};
        [currentSectionCache addObject:dictItem];
    }
    
    [inventoryCache setObject:currentSectionCache forKey:_section.barcode];
    [defaults setObject:inventoryCache forKey:@"inventoryCache"];
    [defaults synchronize];
    
}

- (IBAction)manualInputAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ручной ввод", nil)
                                                    message:NSLocalizedString(@"Введите штрих-код", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Отмена", nil)
                                          otherButtonTitles:NSLocalizedString(@"Отправить", nil), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scanNotification:)
                                                 name:@"BarcodeScanNotification"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) scanNotification:(NSNotification*)aNotification
{
    NSString* barcode = [aNotification.object objectForKey:@"barcode"];
    [self requestItemInformation:barcode];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self save];
}

- (void) cartAddHandler:(NSNotification *)aNotification
{
    [super cartAddHandler:aNotification];
    _shieldView.hidden = YES;
    self.tableView.scrollEnabled = YES;
    [self updateTotalQuantity];
}

- (void) stepperAction:(UIStepper*) sender
{
    ItemInformation *currentItem = self.items[sender.tag];
    [self.itemsCount setObject:[NSNumber numberWithInteger:sender.value] forKey:currentItem.barcode];
    [self updateTotalQuantity];
    
}

- (void) updateTotalQuantity
{
    NSInteger finalQuan = 0;
    NSEnumerator *itemsEnumerator = [self.itemsCount keyEnumerator];
    NSString *currentKey = nil;
    while (currentKey = [itemsEnumerator nextObject]) {
        finalQuan+=[[self.itemsCount objectForKey:currentKey]integerValue];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld", (long)finalQuan];

}

- (void) requestItemInformation:(NSString*) code
{
    [[MCPServer instance] itemDescription:self itemCode:code shopCode:nil isoType:0 progress:nil];
}

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (result == 0 && itemDescription)
    {
//        if (itemDescription.additionalParameters)
//        {
//            id param = itemDescription.additionalParameters[@"ReceiptID"];
//        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Внимание", nil) message:NSLocalizedString(@"Товар не найден в базе", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
    }
    
    //Adding date to item
    
    NSMutableDictionary* paramsWithDate = [itemDescription.additionalParameters mutableCopy];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss.SSSSSSS"];
    
    paramsWithDate[@"date"] = [dateFormatter stringFromDate:[NSDate date]];
    itemDescription.additionalParameters = paramsWithDate;
    
    NSDictionary *userInfo = @{@"item":itemDescription};
    NSNotification *notification = [[NSNotification alloc] initWithName:@"CartAddMessage" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 10 && buttonIndex == alertView.cancelButtonIndex)
    {
        [self.itemsCount removeAllObjects];
        [self.items removeAllObjects];
        [self.tableView reloadData];
        self.shieldView.hidden = NO;
        [self updateTotalQuantity];
        return;
    }
    else if (alertView.tag == 10 && buttonIndex != alertView.cancelButtonIndex)
        return;
    
    if (buttonIndex == alertView.cancelButtonIndex)
        return;
    
    if (alertView.tag == 1)
    {
        [self requestItemInformation:[alertView textFieldAtIndex:0].text];
        return;
    }
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartCell* cell = (CartCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.stepper.tag = indexPath.row;
    ItemInformation *currentItem = self.items[indexPath.row];
    NSNumber *itemsCount = [self.itemsCount objectForKey:currentItem.barcode];
    cell.stepper.value = itemsCount.integerValue;
    [cell.stepper addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
    
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
