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
#import "MCPServer.h"

@interface ReceiveViewController () <AcceptanesDelegate, ItemDescriptionDelegate>
{
    NSMutableArray *_items;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalQuantityLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ReceiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceivesListCell" bundle:nil] forCellReuseIdentifier:@"ListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveBoxCell" bundle:nil] forCellReuseIdentifier:@"BoxCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReceiveItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:60];
    [self setupView];
}

- (void)setupView
{
    if (_rootItem && _rootItem.barcode)
    {
        _bottomView.hidden = NO;
        _bottomView.userInteractionEnabled = YES;
    }
    else
    {
        _bottomView.hidden = YES;
        _bottomView.userInteractionEnabled = NO;
        
        UIImage *sendImage = [UIImage imageNamed:@"send"];
        UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithImage:sendImage style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)];
        self.navigationItem.rightBarButtonItem = sendButton;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [self unsubscribeFromScanNotifications];
}

#pragma mark data

- (void)loadData
{
    [[MCPServer instance] acceptanes:self date:self.date containerBarcode:self.rootItem.barcode];
}

- (void)acceptanesComplete:(int)result items:(NSArray <AcceptanesInformation *>*)items
{
    if (result == 0)
    {
        [_items addObjectsFromArray:items];
        [self.tableView reloadData];
    }
}

- (void)itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (result == 0)
    {
        [self showExcessPickerForItem:itemDescription scanned:1 manually:NO];
    }
}

- (void)addItemToAcception:(ItemInformation *)itemInfo containerBarcode:(NSString *)containerBarcode scanned:(NSUInteger)scanned manually:(BOOL)manually
{
    [[MCPServer instance] addItem:itemInfo toAcceptionWithDate:_date containerBarcode:containerBarcode scannedCount:scanned manually:manually];
}

- (void)updateScreenForItem:(ItemInformation *)itemInfo
{
    for (int i = 0; i < _items.count; i++)
    {
        AcceptanesInformation *acceptInfo = _items[i];
        
        if (acceptInfo.itemInformation.itemId == itemInfo.itemId)
        {
            NSUInteger section = [self numberOfSectionsInTableView:_tableView] - 1;
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            return;
        }
    }
    // item is new excess item
    AcceptanesInformation *acceptInfo = [AcceptanesInformation new];
    acceptInfo.barcode = itemInfo.barcode;
    acceptInfo.containerBarcode = _rootItem.barcode;
    acceptInfo.quantity = @(0);
    acceptInfo.scanned = @(1);
    acceptInfo.itemInformation = itemInfo;
    
    [_items addObject:acceptInfo];
    NSUInteger section = [self numberOfSectionsInTableView:_tableView] - 1;
    NSUInteger row = [_items indexOfObject:acceptInfo];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)acceptAllItems
{
    for (AcceptanesInformation *acceptInfo in _items)
    {
        if ((acceptInfo.type == AcceptanesInformationItemTypeItem) && acceptInfo.scanned.integerValue < acceptInfo.quantity.integerValue)
        {
            acceptInfo.scanned = @(acceptInfo.quantity.integerValue);
            [self addItemToAcception:acceptInfo.itemInformation containerBarcode:_rootItem.barcode scanned:acceptInfo.scanned.integerValue manually:YES];
            [self updateScreenForItem:acceptInfo.itemInformation];
        }
    }
}

#pragma mark Actions

- (IBAction)acceptAllButtonPressed:(id)sender
{
    [self showAcceptAllPicker];
}

- (void)sendButtonPressed:(id)sender
{
    
}

- (void)showExcessPickerForItem:(ItemInformation *)itemInfo scanned:(NSUInteger)scanned manually:(BOOL)manually
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"Отсканированный товар не относится к текущему набору товаров. Выберите действие, которое необходимо совершить" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addToCurrentExcessAction = [UIAlertAction actionWithTitle:@"Добавить в излишки набора" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addItemToAcception:itemInfo containerBarcode:_rootItem.barcode scanned:scanned manually:manually];
        [self updateScreenForItem:itemInfo];
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

- (void)showAcceptAllPicker
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"Вы уверены, что хотите отметить все товары без сканирования?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *acceptAllAction = [UIAlertAction actionWithTitle:@"Отметить все без сканирования" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self acceptAllItems];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:acceptAllAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
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
                [self addItemToAcception:acceptInfo.itemInformation containerBarcode:acceptInfo.containerBarcode scanned:(acceptInfo.scanned.integerValue + 1) manually:NO];
                [self updateScreenForItem:acceptInfo.itemInformation];
            }
            
            return;
        }
    }
    // need to find barcode in current acception and show alert to navigate if it is box
    
    // or find item in database and show alert to choose excess type
    [[MCPServer instance] itemDescription:self itemCode:barcode shopCode:nil isoType:0];
}

#pragma mark - Table view data source

- (NSString *)titleText
{
    if (_rootItem && _rootItem.barcode)
    {
        switch (_rootItem.type)
        {
            case AcceptanesInformationItemTypeBox:
                return [NSString stringWithFormat:@"Коробка %@", _rootItem.barcode];
                break;
            case AcceptanesInformationItemTypeSet:
                return [NSString stringWithFormat:@"Набор товаров %@", _rootItem.barcode];
                break;
            default:
                return nil;
                break;
        }
    }
    else
    {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"d MMMM yyyy, hh:mm";
        return [NSString stringWithFormat:@"%@ %@", (_rootItem ? @"Излишки" : @"Приёмка"), [dateFormatter stringFromDate:self.date]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _rootItem ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_rootItem)
        return section == 0 ? 1 : _items.count;
    else
        return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_rootItem && indexPath.section == 0)
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
    cell.iconImageView.image = [UIImage imageNamed:@"receive_box_icon"];
    cell.titleLabel.text = @"Коробка";
    cell.barcodeLabel.text = item.barcode;
}

- (void)configureSetCell:(ReceiveBoxCell *)cell forItem:(AcceptanesInformation *)item
{
    cell.iconImageView.image = [UIImage imageNamed:@"receive_group_icon"];
    cell.titleLabel.text = @"Набор товаров";
    cell.barcodeLabel.text = item.barcode;
}

- (void)configureItemCell:(ReceiveItemCell *)cell forItem:(AcceptanesInformation *)item
{
    cell.titleLabel.text = item.itemInformation.name;
    cell.barcodeLabel.text = item.barcode;
    cell.quantityLabel.text = [NSString stringWithFormat:@"%ld из %ld", item.scanned.integerValue, item.quantity.integerValue];
    
    UIColor *backgroundColor;
    
    if (item.scanned.integerValue > item.quantity.integerValue)
        backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    else if (item.scanned.integerValue == item.quantity.integerValue)
        backgroundColor = [UIColor colorWithRed:126/255.0 green:211/255.0 blue:33/255.0 alpha:0.5];
    else
        backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:0.3];
    
    cell.backgroundColor = backgroundColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self numberOfSectionsInTableView:self.tableView] == 2 && indexPath.section == 0)
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
    
    header.textLabel.text = [header.textLabel.text capitalizedString];
    header.textLabel.textColor = [UIColor lightGrayColor];
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
        ReceiveViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ReceiveViewController"];
        vc.rootItem = acceptInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
