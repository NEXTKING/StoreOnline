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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalQuantityLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *acceptAllButton;

@end

@implementation ReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivesListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveBoxCell" bundle:nil] forCellReuseIdentifier:@"BoxCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:60];
    [self setupView];
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
        _bottomView.hidden = NO;
        _bottomView.userInteractionEnabled = YES;
        _acceptAllButton.enabled = NO;
        
        UIImage *barcodeImage = [UIImage imageNamed:@"Barcode manual"];
        UIBarButtonItem *manualInputButton = [[UIBarButtonItem alloc] initWithImage:barcodeImage style:UIBarButtonItemStylePlain target:self action:@selector(showManualInputAlert)];
        self.navigationItem.rightBarButtonItem = manualInputButton;
    }
    else
    {
        _bottomView.hidden = YES;
        _bottomView.userInteractionEnabled = NO;
        
        if ([self kind] == AcceptanesControllerKindRoot)
        {
            UIImage *sendImage = [UIImage imageNamed:@"send"];
            UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:sendImage style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)];
            self.navigationItem.rightBarButtonItem = sendButton;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self kind] != AcceptanesControllerKindExcesses)
        [self subscribeToScanNotifications];
    
    if (!_items)
    {
        _items = [[NSMutableArray alloc] init];
        [self loadData];
    }
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
            if ([self kind] == AcceptanesControllerKindRoot)
            {
                NSArray *boxes = [items objectsAtIndexes:[items indexesOfObjectsPassingTest:^BOOL(AcceptanesInformation *acceptInfo, NSUInteger idx, BOOL *stop) {
                    return acceptInfo.type == AcceptanesInformationItemTypeBox;
                }]];
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
        [self updateBottomBar];
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
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Info" message:@"Не удалось найти товар в базе" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
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
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Info" message:@"Не удалось отправить данные приёмки" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
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
    [self updateBottomBar];
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
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"Отсканированный товар не относится к текущему набору товаров. Выберите действие, которое необходимо совершить" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addToCurrentExcessAction = [UIAlertAction actionWithTitle:@"Добавить в излишки набора" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addItemToAcception:itemInfo containerBarcode:_rootItem.barcode scanned:scanned manually:manually];
        [self updateScreenForItem:itemInfo animated:YES];
        [self updateBottomBar];
    }];
    UIAlertAction *addToAllExcessAction = [UIAlertAction actionWithTitle:@"Добавить в общие излишки" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addItemToAcception:itemInfo containerBarcode:nil scanned:scanned manually:manually];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:addToCurrentExcessAction];
    [ac addAction:addToAllExcessAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showNavigateToOtherBoxAlert:(NSArray<AcceptanesInformation*>*)boxHierarhy
{
    NSString *message = [NSString stringWithFormat:@"Отсканирован короб %@", [boxHierarhy lastObject].barcode];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *navigateAction = [UIAlertAction actionWithTitle:@"Перейти" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self navigateToBoxHierarhy:boxHierarhy];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:navigateAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showAcceptAllPicker
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"Вы уверены, что хотите применить все товары без сканирования?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *acceptAllAction = [UIAlertAction actionWithTitle:@"Применить все без сканирования" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self acceptAllItems];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:acceptAllAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showSendAcceptanesDataPicker
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"Отправить данные приёмки на сервер?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"Отправить" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sendAcceptanesData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:sendAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showCloseAcceptionAlert
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"Данные переданы успешно. Завершить приёмку?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Завершить" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self closeAcception];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Продолжить" style:UIAlertActionStyleDefault handler:nil];
    
    [ac addAction:closeAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showManualInputAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ручной ввод" message:@"Введите штрих-код" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отправить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
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
                [self pushToAcceptItem:acceptInfo];
            else
            {
                acceptInfo.scanned = @(acceptInfo.scanned.integerValue + 1);
                [self addItemToAcception:acceptInfo containerBarcode:acceptInfo.containerBarcode scanned:acceptInfo.scanned.integerValue manually:NO];
                [self updateScreenForItem:acceptInfo animated:YES];
                [self updateBottomBar];
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

- (void)updateBottomBar
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
        _totalQuantityLabel.text = [NSString stringWithFormat:@"Итого: %ld из %ld товаров", itemsCount, totalItemsCount];
        _acceptAllButton.enabled = (itemsWithoutExcessCount != totalItemsCount);
    }
    else
    {
        _totalQuantityLabel.text = @"Нет товаров";
    }
}

- (NSString *)titleText
{
    if ([self kind] == AcceptanesControllerKindRegular)
    {
        switch (_rootItem.type)
        {
            case AcceptanesInformationItemTypeBox:
                return [NSString stringWithFormat:@"Короб %@", _rootItem.barcode];
                break;
            case AcceptanesInformationItemTypeSet:
                return [NSString stringWithFormat:@"Набор товаров %@", _rootItem.barcode];
                break;
            default:
                return nil;
                break;
        }
    }
    else if ([self kind] == AcceptanesControllerKindExcesses)
    {
        return @"Общие излишки";
    }
    else
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"d MMMM yyyy";
        return [NSString stringWithFormat:@"Приёмка %@", [dateFormatter stringFromDate:self.date]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self kind] == AcceptanesControllerKindRoot ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self kind] == AcceptanesControllerKindRoot)
        return section == 0 ? 1 : _items.count;
    else
        return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self kind] == AcceptanesControllerKindRoot && indexPath.section == 0)
    {
        ReceivesListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
        
        cell.titleLabel.text = @"Общие излишки";
        
        return cell;
    }
    else
    {
        id cell;
        AcceptanesInformation *item = _items[indexPath.row];
        switch (item.type)
        {
            case AcceptanesInformationItemTypeBox:
                cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell" forIndexPath:indexPath];
                [self configureBoxCell:cell forItem:item];
                break;
            case AcceptanesInformationItemTypeSet:
                cell = [tableView dequeueReusableCellWithIdentifier:@"BoxCell" forIndexPath:indexPath];
                [self configureSetCell:cell forItem:item];
                break;
            case AcceptanesInformationItemTypeItem:
                cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
                [self configureItemCell:cell forItem:item];
                break;
            default:
                break;
        }
        return cell ? cell : [UITableViewCell new];
    }
}

- (void)configureBoxCell:(ReceiveBoxCell *)cell forItem:(AcceptanesInformation *)item
{
    cell.titleLabel.text = ([self kind] == AcceptanesControllerKindRoot) ? @"Накладная" : @"Короб";
    cell.barcodeLabel.text = item.barcode;
}

- (void)configureSetCell:(ReceiveBoxCell *)cell forItem:(AcceptanesInformation *)item
{
    cell.titleLabel.text = @"Набор товаров";
    cell.barcodeLabel.text = item.barcode;
}

- (void)configureItemCell:(ReceiveItemCell *)cell forItem:(AcceptanesInformation *)item
{
    cell.titleLabel.text = item.name;
    cell.barcodeLabel.text = item.barcode;
    cell.quantityLabel.text = [NSString stringWithFormat:@"%ld из %ld", item.scanned.integerValue, item.quantity.integerValue];
    
    UIColor *backgroundColor;
    
    if (item.scanned.integerValue > item.quantity.integerValue)
        backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    else if (item.scanned.integerValue == item.quantity.integerValue)
        backgroundColor = [UIColor colorWithRed:126/255.0 green:211/255.0 blue:33/255.0 alpha:0.5];
    else
        backgroundColor = [UIColor whiteColor];
    
    cell.backgroundColor = backgroundColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self kind] == AcceptanesControllerKindRoot && indexPath.section == 0)
    {
        AcceptanesInformation *excessBox = [AcceptanesInformation new];
        excessBox.type = AcceptanesInformationItemTypeBox;
        [self pushToAcceptItem:excessBox];
    }
    else
    {
        AcceptanesInformation *item = _items[indexPath.row];
        [self pushToAcceptItem:item];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? self.titleText : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.text = [self titleText];
    header.textLabel.font = [UIFont boldSystemFontOfSize:12];
    header.textLabel.frame = header.frame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
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
