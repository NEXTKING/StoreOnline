//
//  InventorySectionsViewController.m
//  PriceTagDemo
//
//  Created by denis on 13.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "InventorySectionsViewController.h"
#import "InventoryViewController.h"
#import "MCPServer.h"
#import "AppAppearance.h"
#import "InventorySectionCell.h"

@implementation SectionDescription
@end

@interface InventorySectionsViewController () <UIAlertViewDelegate, SendCartDelegate>

@property (nonatomic, strong) NSArray* sections;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *startInventoryButton;

@end

@implementation InventorySectionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Инвентаризация", nil);
    [_startInventoryButton setTitle:NSLocalizedString(@"Начать новую инвентаризацию", nil) forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:@"InventorySectionCell" bundle:nil] forCellReuseIdentifier:@"InventorySectionCell"];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:44];
    
    self.tableView.separatorColor = AppAppearance.sharedApperance.tableViewSeparatorColor;
    self.tableView.separatorStyle = AppAppearance.sharedApperance.tableViewSeparatorStyle;
    self.tableView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:AppAppearance.sharedApperance.navigationBarSendButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonAction:)];
    self.navigationItem.rightBarButtonItem = sendButton;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scanNotification:)
                                                 name:@"BarcodeScanNotification"
                                               object:nil];
    
    if (_selectedIndexPath)
    {
        [self.tableView reloadRowsAtIndexPaths:@[_selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        self.selectedIndexPath = nil;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) scanNotification:(NSNotification*)aNotification
{
    NSString* barcode = [aNotification.object objectForKey:@"barcode"];
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
        [self showInfoMessage:NSLocalizedString(@"Секция с таким штрих-кодом не найдена", nil)];
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
    
    InventorySectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* inventoryCache = [defaults objectForKey:@"inventoryCache"];
    
    SectionDescription *currentSection = _sections[indexPath.row];
    NSArray *currentSectionCache = [inventoryCache objectForKey:currentSection.barcode];
    
    cell.titleLabel.text = currentSection.name;
    cell.barcodeLabel.text = currentSection.barcode;
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    cell.backgroundColor = (currentSectionCache.count>0) ? AppAppearance.sharedApperance.tableViewCellBackgroundGreenColor : AppAppearance.sharedApperance.tableViewCellBackgroundColor;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"InventorySegue" sender:nil];
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
    UIAlertController* secondaryAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Вы действительно хотите начать новую инвентаризацию?", nil)
                                                                            message:nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* decline = [UIAlertAction actionWithTitle:NSLocalizedString(@"Нет", nil) style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {}];
    UIAlertAction* confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"Да", nil) style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * action) {[self endOfInventory];}];
    
    [secondaryAlert addAction:decline];
    [secondaryAlert addAction:confirm];
    [self presentViewController:secondaryAlert animated:YES completion:nil];

}

- (void) sendInventory
{
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Инфо", nil) message:NSLocalizedString(@"Отправить товары на сервер?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Нет", nil) otherButtonTitles:NSLocalizedString(@"Да", nil), nil];
        [alert show];
    }
}

-(void) endOfInventory
{
    NSString* currentShopId = [[NSUserDefaults standardUserDefaults] objectForKey:@"shopID"];
    if (!currentShopId)
    {
        [self showInfoMessage:NSLocalizedString(@"Необходимо выполнить синхронизацию", nil)];
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
                [self showInfoMessage:NSLocalizedString(@"Перед отправкой необходимо отсканировать хотя бы один товар", nil)];
                
        }
        else
            [self showInfoMessage:NSLocalizedString(@"Перед отправкой необходимо отсканировать хотя бы один товар", nil)];
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
        [self showInfoMessage:NSLocalizedString(@"Товары успешно отправлены!", nil)];
    }
    else
    {
        [self showInfoMessage:NSLocalizedString(@"Не удалось отправить товары. Убедитесь в наличии подключения к сети.", nil)];
    }
}

- (void) endOfInventComplete:(int)result
{
    if (result == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"inventoryCache"];
        [self showInfoMessage:NSLocalizedString(@"Новая инвентаризация успешно начата", nil)];
        [self.tableView reloadData];
        
    }
    else
    {
        [self showInfoMessage:NSLocalizedString(@"Не удалось завершить инвентаризацию. Убедитесь в наличии подключения к сети.", nil)];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InventoryViewController *inventoryVC = segue.destinationViewController;
    
    NSIndexPath* indexPath = _selectedIndexPath;//[self.tableView indexPathForCell:sender];
    
    SectionDescription *description = _sections[indexPath.row];
    inventoryVC.section = description;
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:info delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


@end
