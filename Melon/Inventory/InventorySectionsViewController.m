//
//  InventorySectionsViewController.m
//  PriceTagDemo
//
//  Created by denis on 13.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "InventorySectionsViewController.h"
#import "InventoryViewController.h"
#import "DTDevices.h"
#import "MCPServer.h"

@implementation SectionDescription
@end

@interface InventorySectionsViewController () <DTDeviceDelegate, UIAlertViewDelegate, SendCartDelegate>

@property (nonatomic, strong) NSArray* sections;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation InventorySectionsViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev addDelegate:self];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    if (_selectedIndexPath)
    {
        [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        self.selectedIndexPath = nil;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev removeDelegate:self];
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    [self handleBarcodeData:barcode];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [self handleBarcodeData:barcode];
}

- (void) handleBarcodeData :(NSString*) code;
{
    NSInteger number = NSNotFound;
    for (int i = 0; i < _sections.count; ++i) {
        SectionDescription *currentSection = _sections[i];
        if ([currentSection.barcode isEqualToString:code])
        {
            number = i;
            break;
        }
    }
    
    if (number == NSNotFound)
        [self showInfoMessage:@"Секция с таким штрих-кодом не найдена"];
    else
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:number inSection:0]];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self internalInit];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self internalInit];
    }
    
    return self;
}

- (void) internalInit
{
    NSMutableArray *staticSectionsArray = [NSMutableArray new];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*path = [[NSString alloc] initWithFormat:@"%@/zones.arch", docDir];
    NSArray* sectionsData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    for (NSDictionary* zoneDict in sectionsData) {
        SectionDescription *section = [SectionDescription new];
        section.name    = [zoneDict objectForKey:@"Description"];
        section.barcode = [zoneDict objectForKey:@"ZoneCode"];
        [staticSectionsArray addObject:section];
    }
    
    self.sections = staticSectionsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sections.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"InventorySectionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* inventoryCache = [defaults objectForKey:@"inventoryCache"];
    
    SectionDescription *currentSection = _sections[indexPath.row];
    NSArray *currentSectionCache = [inventoryCache objectForKey:currentSection.barcode];
    
    cell.textLabel.text = currentSection.name;
    cell.detailTextLabel.text = currentSection.barcode;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.backgroundColor = (currentSectionCache.count>0) ? [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.2]:[UIColor whiteColor];
    
    // Configure the cell...
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
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

- (IBAction)sendButtonAction:(id)sender
{
    [self sendInventory];
}

- (IBAction)startNewInventory:(id)sender
{
    UIAlertController* secondaryAlert = [UIAlertController alertControllerWithTitle:@"Вы действительно хотите начать новую инвентаризацию?"
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* decline = [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {}];
    UIAlertAction* confirm = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * action) {[self endOfInventory];}];
    
    [secondaryAlert addAction:decline];
    [secondaryAlert addAction:confirm];
    [self presentViewController:secondaryAlert animated:YES completion:nil];

}

- (void) sendInventory
{
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Инфо" message:@"Отправить товары на сервер?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да", nil];
        [alert show];
    }
}

-(void) endOfInventory
{
    NSString* currentShopId = [[NSUserDefaults standardUserDefaults] objectForKey:@"shopID"];
    if (!currentShopId)
    {
        [self showInfoMessage:@"Необходимо выполнить синхронизацию"];
        return;
    }
    
    [[MCPServer instance] endOfInvent:self shopID:currentShopId password:nil];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* inventoryCache = [defaults objectForKey:@"inventoryCache"];
        NSMutableArray* array = [NSMutableArray new];
        
        if (inventoryCache)
        {
            
            NSEnumerator *keyEnumerator = [inventoryCache keyEnumerator];
            NSString *currentKey = nil;
            while (currentKey = [keyEnumerator nextObject]) {
                
                NSMutableArray* items = [NSMutableArray new];
                NSMutableDictionary*itemsCount = [NSMutableDictionary new];
            
                NSArray *currentSectionCache = [inventoryCache objectForKey:currentKey];
                if (currentSectionCache.count > 0)
                {
                    for (NSDictionary* dictItem in currentSectionCache) {
                        NSData* encodedItemInfo = [dictItem objectForKey:@"object"];
                        ItemInformation* itemInfo = (ItemInformation*)[NSKeyedUnarchiver unarchiveObjectWithData:encodedItemInfo];
                        NSNumber* quantity        = [dictItem objectForKey:@"quantity"];
                    
                        if (itemInfo)
                        {
                            [items addObject:itemInfo];
                            [itemsCount setObject:quantity forKey:itemInfo.barcode];
                        }
                    }
                
                }
                
                
                for (ItemInformation* item in items) {
                    NSNumber* qty = [itemsCount objectForKey:item.barcode];
                    NSDictionary *dict = @{@"barcode":item.barcode, @"qty":qty, @"section":currentKey, @"date":[self getStringDateFromItem:item]};
                    [array addObject:dict];
                }
                
            }
            
            NSDictionary* toSend = @{@"items":array};
            
            if (array.count > 0)
                [[MCPServer instance] sendCart:self cartData:toSend];
            else
                [self showInfoMessage:@"Перед отправкой необходимо отсканировать хотя бы один товар"];
                
        }
        else
            [self showInfoMessage:@"Перед отправкой необходимо отсканировать хотя бы один товар"];
    }
}

- (NSString*) getStringDateFromItem:(ItemInformation*) item
{
    for (ParameterInformation* param in item.additionalParameters) {
        if ([param.name isEqualToString:@"date"])
        {
            return param.value;
        }
    }
    
    return @"";
}

- (void) sendCartComplete:(int)result
{
    if (result == 0)
    {
        [self showInfoMessage:@"Товары успешно отправлены!"];
    }
    else
    {
        [self showInfoMessage:@"Не удалось отправить товары. Убедитесь в наличии подключения к сети."];
    }
}

- (void) endOfInventComplete:(int)result
{
    if (result == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"inventoryCache"];
        [self showInfoMessage:@"Новая инвентаризация успешно начата"];
        [self.tableView reloadData];
        
    }
    else
    {
        [self showInfoMessage:@"Не удалось завершить инвентаризацию. Убедитесь в наличии подключения к сети."];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InventoryViewController *inventoryVC = segue.destinationViewController;
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    
    SectionDescription *description = _sections[indexPath.row];
    inventoryVC.section = description;
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:info delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


@end
