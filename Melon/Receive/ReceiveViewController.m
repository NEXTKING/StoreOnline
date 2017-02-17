//
//  ReceiveViewController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ReceiveViewController.h"
#import "ReceivesListCell.h"
#import "ReceiveBoxCell.h"
#import "ReceiveItemCell.h"
#import "ReceivesListViewController.h"
#import "MCPServer.h"
#import "AppAppearance.h"

typedef enum : NSUInteger
{
    AcceptanesControllerKindRoot = (1 << 0),
    AcceptanesControllerKindExcesses = (1 << 1),
    AcceptanesControllerKindRegular = (1 << 2)
}AcceptanesControllerKind;

@interface ReceiveViewController () <AcceptanesDelegate>
{
    NSMutableArray *_items;
    NSString *_lastBarcode;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *totalQuantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *acceptAllButton;

@end

@implementation ReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = AppAppearance.sharedApperance.tableViewSeparatorColor;
    self.tableView.separatorStyle = AppAppearance.sharedApperance.tableViewSeparatorStyle;
    self.tableView.separatorInset = AppAppearance.sharedApperance.tableViewSeparatorInsets;
    self.tableView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    self.headerView.backgroundColor = AppAppearance.sharedApperance.tableViewSectionHeaderBackgroundColor;
    self.titleLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Font;
    self.titleLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Color;
    self.totalQuantityLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle2Font;
    self.totalQuantityLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle2Color;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivesListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveBoxCell" bundle:nil] forCellReuseIdentifier:@"BoxCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:60];
    [self setupView];
    
    self.title = NSLocalizedString(@"Приёмка", nil);
}

- (AcceptanesControllerKind)kind
{
    if (_rootItem && _rootItem.barcode)
        return AcceptanesControllerKindRegular;
    else if (_rootItem)
        return AcceptanesControllerKindExcesses;
    else
        return AcceptanesControllerKindRoot;
}

- (void)setupView
{
    if ([self kind] == AcceptanesControllerKindRegular)
    {
        _acceptAllButton.hidden = NO;
        _acceptAllButton.enabled = NO;
        
        UIBarButtonItem *manualInputButton = [[UIBarButtonItem alloc] initWithImage:AppAppearance.sharedApperance.navigationBarManualInputImage style:UIBarButtonItemStylePlain target:self action:@selector(showManualInputAlert)];
        self.navigationItem.rightBarButtonItem = manualInputButton;
        
        switch (_rootItem.type)
        {
            case AcceptanesInformationItemTypeBox:
                _titleLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Короб", nil), _rootItem.barcode];
                break;
            case AcceptanesInformationItemTypeSet:
                _titleLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Набор товаров", nil), _rootItem.barcode];
                break;
            default:
                break;
        }
        
        NSUInteger selfIndex = [self.navigationController.viewControllers indexOfObject:self];
        ReceiveViewController *prevVC = self.navigationController.viewControllers[selfIndex - 1];
        if ([prevVC kind] == AcceptanesControllerKindRoot)
            _titleLabel.text = self.rootItem.name;
    }
    else
    {
        _acceptAllButton.hidden = YES;
        
        if ([self kind] == AcceptanesControllerKindRoot)
        {
            UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:AppAppearance.sharedApperance.navigationBarSendButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)];
            self.navigationItem.rightBarButtonItem = sendButton;
            
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"d MMMM yyyy";
            
            _titleLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Приёмка", nil), [dateFormatter stringFromDate:self.date]];
        }
        else
        {
            _titleLabel.text = NSLocalizedString(@"Общие излишки", nil);
        }
    }
    [_acceptAllButton setTitle:NSLocalizedString(@"Применить все без сканирования", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self kind] != AcceptanesControllerKindExcesses)
        [self subscribeToScanNotifications];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self kind] != AcceptanesControllerKindExcesses)
        [self unsubscribeFromScanNotifications];
}

#pragma mark data

- (void)loadData
{
    [[MCPServer instance] acceptanes:self date:self.date itemBarcode:nil containerBarcode:self.rootItem.barcode];
}

- (void)acceptanesComplete:(int)result items:(NSArray <AcceptanesInformation *>*)items
{
    if (!_lastBarcode)
    {
        if (result == 0)
        {
            _items = [[NSMutableArray alloc] init];
            
            if ([self kind] == AcceptanesControllerKindRoot)
            {
                NSArray *boxes = [items objectsAtIndexes:[items indexesOfObjectsPassingTest:^BOOL(AcceptanesInformation *acceptInfo, NSUInteger idx, BOOL *stop) {
                    return acceptInfo.type == AcceptanesInformationItemTypeBox;
                }]];
                
                AcceptanesInformation *excessBox = [AcceptanesInformation new];
                excessBox.type = AcceptanesInformationItemTypeBox;
                [_items addObject:excessBox];
                [_items addObjectsFromArray:boxes];
            }
            else if ([self kind] == AcceptanesControllerKindExcesses)
            {
                NSArray *excessItems = [items objectsAtIndexes:[items indexesOfObjectsPassingTest:^BOOL(AcceptanesInformation *acceptInfo, NSUInteger idx, BOOL *stop) {
                    return acceptInfo.type == AcceptanesInformationItemTypeItem;
                }]];
                [_items addObjectsFromArray:excessItems];
            }
            else
            {
                [_items addObjectsFromArray:items];
            }
            
            [self.tableView reloadData];
        }
        [self updateTotalQuantity];
    }
    else
    {
        if (result == 0)
        {
            AcceptanesInformation *item = items[0];
            [self showExcessPickerForItem:item scanned:1 manually:NO];
        }
        else
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"Не удалось найти товар в базе", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:cancelAction];
            [self presentViewController:ac animated:YES completion:nil];
        }
        _lastBarcode = nil;
    }
}

- (void)acceptanesHierarchyComplete:(int)result items:(NSArray<AcceptanesInformation *> *)items
{
    if (result == 0)
    {
        [self showNavigateToOtherBoxAlert:items];
    }
    else if (_lastBarcode)
    {
        [[MCPServer instance] acceptanes:self date:self.date itemBarcode:_lastBarcode containerBarcode:nil];
    }
}

-(void)sendAcceptanesComplete:(int)result
{
    if (result == 0)
    {
        [self showCloseAcceptionAlert];
    }
    else
    {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Info", nil) message:NSLocalizedString(@"Не удалось отправить данные приёмки", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
}
- (void)addItemToAcception:(AcceptanesInformation *)itemInfo containerBarcode:(NSString *)containerBarcode scanned:(NSUInteger)scanned manually:(BOOL)manually
{
    [[MCPServer instance] addItem:itemInfo toAcceptionWithDate:_date containerBarcode:containerBarcode scannedCount:scanned manually:manually];
}

- (void)updateScreenForItem:(AcceptanesInformation *)itemInfo animated:(BOOL)animated
{
    for (int i = 0; i < _items.count; i++)
    {
        AcceptanesInformation *acceptInfo = _items[i];
        
        if ([acceptInfo.barcode isEqualToString:itemInfo.barcode])
        {
            NSUInteger section = [self numberOfSectionsInTableView:_tableView] - 1;
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
            [_tableView reloadRowsAtIndexPaths:@[itemIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (animated)
                [_tableView scrollToRowAtIndexPath:itemIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            return;
        }
    }
    // item is new excess item
    AcceptanesInformation *acceptInfo = [AcceptanesInformation new];
    acceptInfo.barcode = itemInfo.barcode;
    acceptInfo.containerBarcode = _rootItem.barcode;
    acceptInfo.quantity = @(0);
    acceptInfo.scanned = @(1);
    acceptInfo.type = AcceptanesInformationItemTypeItem;
    acceptInfo.name = itemInfo.name;
    
    [_items addObject:acceptInfo];
    NSUInteger section = [self numberOfSectionsInTableView:_tableView] - 1;
    NSUInteger row = [_items indexOfObject:acceptInfo];
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [_tableView insertRowsAtIndexPaths:@[itemIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (animated)
        [_tableView scrollToRowAtIndexPath:itemIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)acceptAllItems
{
    for (AcceptanesInformation *acceptInfo in _items)
    {
        if ((acceptInfo.type == AcceptanesInformationItemTypeItem) && acceptInfo.scanned.integerValue < acceptInfo.quantity.integerValue && acceptInfo.quantity.integerValue != 0)
        {
            acceptInfo.scanned = @(acceptInfo.quantity.integerValue);
            [self addItemToAcception:acceptInfo containerBarcode:_rootItem.barcode scanned:acceptInfo.scanned.integerValue manually:YES];
            [self updateScreenForItem:acceptInfo animated:NO];
        }
    }
    [self updateTotalQuantity];
}

- (void)navigateToBoxHierarhy:(NSArray<AcceptanesInformation*>*)boxHierarhy
{
    for (int i = 0; i < self.navigationController.viewControllers.count; i++)
    {
        if ([self.navigationController.viewControllers[i] isKindOfClass:[ReceivesListViewController class]])
        {
            ReceivesListViewController *vc = self.navigationController.viewControllers[i];
            [vc createViewControllersHierarhyWithAcceptanesInfos:boxHierarhy];
            break;
        }
    }
}

- (void)sendAcceptanesData
{
    [[MCPServer instance] sendAcceptanes:self date:_date shopID:[[NSUserDefaults standardUserDefaults] valueForKey:@"shopID"]];
}

- (void)closeAcception
{
    NSMutableArray *closedAcceptions = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"ClosedAcceptions"] mutableCopy];
    if (closedAcceptions == nil)
        closedAcceptions = [NSMutableArray new];
    
    [closedAcceptions addObject:_date];
    
    [[NSUserDefaults standardUserDefaults] setObject:closedAcceptions forKey:@"ClosedAcceptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Actions

- (IBAction)acceptAllButtonPressed:(id)sender
{
    [self showAcceptAllPicker];
}

- (void)sendButtonPressed:(id)sender
{
    [self showSendAcceptanesDataPicker];
}

- (void)showExcessPickerForItem:(AcceptanesInformation *)itemInfo scanned:(NSUInteger)scanned manually:(BOOL)manually
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Отсканированный товар не относится к текущему набору товаров. Выберите действие, которое необходимо совершить", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addToCurrentExcessAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Добавить в излишки набора", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addItemToAcception:itemInfo containerBarcode:_rootItem.barcode scanned:scanned manually:manually];
        [self updateScreenForItem:itemInfo animated:YES];
        [self updateTotalQuantity];
    }];
    UIAlertAction *addToAllExcessAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Добавить в общие излишки", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addItemToAcception:itemInfo containerBarcode:nil scanned:scanned manually:manually];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:addToCurrentExcessAction];
    [ac addAction:addToAllExcessAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showNavigateToOtherBoxAlert:(NSArray<AcceptanesInformation*>*)boxHierarhy
{
    NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Отсканирован короб", nil), [boxHierarhy lastObject].barcode];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *navigateAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Перейти", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        AcceptanesInformation *acceptInfo = [boxHierarhy lastObject];
        acceptInfo.scanned = @(acceptInfo.scanned.integerValue + 1);
        [self addItemToAcception:acceptInfo containerBarcode:acceptInfo.containerBarcode scanned:acceptInfo.scanned.integerValue manually:NO];
        
        [self navigateToBoxHierarhy:boxHierarhy];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:navigateAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAcceptAllPicker
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Вы уверены, что хотите применить все товары без сканирования?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *acceptAllAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Применить все без сканирования", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self acceptAllItems];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:acceptAllAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showSendAcceptanesDataPicker
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Отправить данные приёмки на сервер?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отправить", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sendAcceptanesData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:sendAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showCloseAcceptionAlert
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Данные переданы успешно. Завершить приёмку?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Завершить", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self showConfirmCloseAcceptionAlert];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Продолжить", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [ac addAction:closeAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showConfirmCloseAcceptionAlert
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Вы уверены, что хотите завершить приёмку?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Завершить", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self closeAcception];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:closeAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showManualInputAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Ручной ввод", nil) message:NSLocalizedString(@"Введите штрих-код", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отправить", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        NSDictionary* params = @{@"barcode":alert.textFields[0].text, @"type":@(0)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BarcodeScanNotification"object:params];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        
         textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Notifications

- (void)subscribeToScanNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveScanNotification:) name:@"BarcodeScanNotification" object:nil];
}

- (void)unsubscribeFromScanNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BarcodeScanNotification" object:nil];
}

- (void)didReceiveScanNotification:(NSNotification *)notification
{
    NSString *barcode = notification.object[@"barcode"];
    
    for (AcceptanesInformation *acceptInfo in _items)
    {
        if ([acceptInfo.barcode isEqualToString:barcode])
        {
            if (acceptInfo.type == AcceptanesInformationItemTypeBox || acceptInfo.type == AcceptanesInformationItemTypeSet)
            {
                acceptInfo.scanned = @(acceptInfo.scanned.integerValue + 1);
                [self addItemToAcception:acceptInfo containerBarcode:acceptInfo.containerBarcode scanned:acceptInfo.scanned.integerValue manually:NO];
                
                [self pushToAcceptItem:acceptInfo];
            }
            else
            {
                acceptInfo.scanned = @(acceptInfo.scanned.integerValue + 1);
                [self addItemToAcception:acceptInfo containerBarcode:acceptInfo.containerBarcode scanned:acceptInfo.scanned.integerValue manually:NO];
                [self updateScreenForItem:acceptInfo animated:YES];
                [self updateTotalQuantity];
            }
            
            return;
        }
    }
    // need to find barcode in current acception and show alert to navigate if it is box
    // or find item in database and show alert to choose excess type
    _lastBarcode = barcode;
    [[MCPServer instance] acceptanesHierarchy:self date:_date barcode:barcode];
}

#pragma mark - Table view data source

- (void)updateTotalQuantity
{
    __block NSInteger itemsCount = 0;
    __block NSInteger itemsWithoutExcessCount = 0;
    __block NSInteger totalItemsCount = 0;
    
    [_items enumerateObjectsUsingBlock:^(AcceptanesInformation *acceptInfo, NSUInteger idx, BOOL *stop) {
        if (acceptInfo.type == AcceptanesInformationItemTypeItem)
        {
            itemsCount += acceptInfo.scanned.integerValue;
            totalItemsCount += acceptInfo.quantity.integerValue;
            if (acceptInfo.quantity.integerValue != 0)
                itemsWithoutExcessCount += acceptInfo.scanned.integerValue;
        }
    }];
    
    if (totalItemsCount > 0)
    {
        _totalQuantityLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Итого: %ld из %ld товаров", nil), itemsCount, totalItemsCount];
        _acceptAllButton.enabled = (itemsWithoutExcessCount != totalItemsCount);
    }
    else
    {
        _totalQuantityLabel.text = ([self kind] == AcceptanesControllerKindRegular) ? NSLocalizedString(@"Нет товаров", nil) : @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self kind] == AcceptanesControllerKindRoot && indexPath.row == 0)
    {
        ReceivesListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = NSLocalizedString(@"Общие излишки", nil);
        cell.positionLabel.text = @"";
        return cell;
    }
    else
    {
        NSUInteger row = ([self kind] == AcceptanesControllerKindRoot) ? indexPath.row : indexPath.row + 1;
        id cell;
        AcceptanesInformation *item = _items[indexPath.row];
        switch (item.type)
        {
            case AcceptanesInformationItemTypeBox:
                cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell" forIndexPath:indexPath];
                [self configureBoxCell:cell forItem:item rowNum:row];
                break;
            case AcceptanesInformationItemTypeSet:
                cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell" forIndexPath:indexPath];
                [self configureSetCell:cell forItem:item rowNum:row];
                break;
            case AcceptanesInformationItemTypeItem:
                cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
                [self configureItemCell:cell forItem:item rowNum:row];
                break;
            default:
                break;
        }
        return cell ? cell : [UITableViewCell new];
    }
}

- (void)configureBoxCell:(ReceiveBoxCell *)cell forItem:(AcceptanesInformation *)item rowNum:(NSUInteger)rowNum
{
    if ([self kind] == AcceptanesControllerKindRoot)
    {
        cell.titleLabel.text = NSLocalizedString(@"Накладная", nil);
        [cell setDefaultStyle];
    }
    else
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ (%ld/%ld)", NSLocalizedString(@"Короб", nil), item.scanned.integerValue, item.quantity.integerValue];
        (item.scanned.integerValue == item.quantity.integerValue) ? [cell setCompleteStyle] : [cell setDefaultStyle];
    }
    cell.barcodeLabel.text = item.barcode;
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", rowNum];
}

- (void)configureSetCell:(ReceiveBoxCell *)cell forItem:(AcceptanesInformation *)item rowNum:(NSUInteger)rowNum
{
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ (%ld/%ld)", NSLocalizedString(@"Набор товаров", nil), item.scanned.integerValue, item.quantity.integerValue];
    cell.barcodeLabel.text = item.barcode;
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", rowNum];
    
    (item.scanned.integerValue == item.quantity.integerValue) ? [cell setCompleteStyle] : [cell setDefaultStyle];
}

- (void)configureItemCell:(ReceiveItemCell *)cell forItem:(AcceptanesInformation *)item rowNum:(NSUInteger)rowNum
{
    cell.titleLabel.text = item.name;
    cell.barcodeLabel.text = item.barcode;
    cell.quantityLabel.text = [NSString stringWithFormat:@"%ld %@ %ld", item.scanned.integerValue, NSLocalizedString(@"из", nil), item.quantity.integerValue];
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", rowNum];

    if (item.scanned.integerValue > item.quantity.integerValue)
        [cell setExcessStyle];
    else if (item.scanned.integerValue == item.quantity.integerValue)
        [cell setCompleteStyle];
    else
        [cell setDefaultStyle];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AcceptanesInformation *item = _items[indexPath.row];
    if (item.containerBarcode == nil)
        [self pushToAcceptItem:item];
    else
    {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Отсканируйте штрих-код", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.headerView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.headerView.frame.size.height : 0;
}

#pragma mark Navigation

- (void)pushToAcceptItem:(AcceptanesInformation *)acceptInfo
{
    if (acceptInfo.type == AcceptanesInformationItemTypeBox || acceptInfo.type == AcceptanesInformationItemTypeSet)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReceiveViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ReceiveVC"];
        vc.rootItem = acceptInfo;
        vc.date = _date;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
