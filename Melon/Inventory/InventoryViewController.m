//
//  InventoryViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 28.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "InventoryViewController.h"
#import "MCPServer.h"
#import "DTDevices.h"
#import "CartCell.h"

@interface InventoryViewController () <UIAlertViewDelegate>
{
}

@end

@implementation InventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _statusView.layer.cornerRadius = _statusView.frame.size.height/2;
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice connect];
    [self connectionState:dtDevice.connstate];
    
    _sectionLabel.text = [NSString stringWithFormat:@"Зона: %@", _section.name];
    
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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Продолжить существующий список?" delegate:self cancelButtonTitle:@"Очистить" otherButtonTitles:@"Продолжить", nil];
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
    
    // Do any additional setup after loading the view.
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

- (void) connectionState:(int)state
{
    switch (state) {
        case CONN_CONNECTED:
        {
            _statusView.backgroundColor = [UIColor greenColor];
            //[dtDevice emsrConfigMaskedDataShowExpiration:TRUE showServiceCode:TRUE showTrack3:FALSE unmaskedDigitsAtStart:6 unmaskedDigitsAtEnd:2 unmaskedDigitsAfter:7 error:nil];
            //[dtDevice emsrSetEncryption:7 keyID:2 params:nil error:nil];
            //[printVC startSearchingPtinter];
            
        }
            break;
        case CONN_CONNECTING:
            _statusView.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
        case CONN_DISCONNECTED:
            _statusView.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (IBAction)manualInputAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ручной ввод"
                                                    message:@"Введите штрих-код"
                                                   delegate:self
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"Отправить",nil];
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
    
    _countLabel.text = [NSString stringWithFormat:@"Количество: %ld", (long)finalQuan];

}

- (void) requestItemInformation:(NSString*) code
{
    [[MCPServer instance] itemDescription:self itemCode:code shopCode:nil isoType:0];
}

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (result == 0 && itemDescription)
    {
        if (itemDescription.additionalParameters.count > 0)
        {
            ParameterInformation*param = nil;
            for (ParameterInformation* currentParam in itemDescription.additionalParameters) {
                if ([currentParam.name isEqualToString:@"ReceiptID"])
                    param = currentParam;
            }
        }
    }
    else
    {
        
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Товар не найден в базе" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.tag = 0;
            [alert show];
    
    }
    
    //Adding date to item
    
    NSMutableArray* paramsWithDate = [[NSMutableArray alloc] initWithArray:itemDescription.additionalParameters];
    
    ParameterInformation* paramInfo = [ParameterInformation new];
    paramInfo.name = @"date";
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss.SSSSSSS"];
    paramInfo.value = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"%@", paramInfo.value);
    
    [paramsWithDate addObject:paramInfo];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:info delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
