//
//  CartViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"
#import "CartFooterView.h"

@interface CartViewController () <UIAlertViewDelegate>
{
    BOOL shouldReloadCart;
    CALayer *headerBottomBorder;
}

@end

@implementation CartViewController


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.items = [[NSMutableArray alloc] init];
        self.itemsCount = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartAddHandler:) name:@"CartAddMessage" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _footerView.totalLabel.text = @"0.00";
    [_footerView.clearButton addTarget:self action:@selector(clearCartAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    headerBottomBorder = [CALayer layer];
    headerBottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    [_cartHeader.layer addSublayer:headerBottomBorder];
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    headerBottomBorder.frame = CGRectMake(20.0f, _cartHeader.frame.size.height-1, _cartHeader.frame.size.width-40, 1.0f);
}

- (void) cartAddHandler:(NSNotification*) aNotification
{
    ItemInformation *itemInfo = [aNotification.userInfo objectForKey:@"item"];
    if (itemInfo)
    {
        NSInteger itemQuantity = 1;
        if ([_itemsCount objectForKey:itemInfo.barcode])
            itemQuantity = [[_itemsCount objectForKey:itemInfo.barcode] integerValue] + 1;
        else
            [_items addObject:itemInfo];
        
        [_itemsCount setObject:[NSNumber numberWithInteger:itemQuantity] forKey:itemInfo.barcode];
    }
    
    shouldReloadCart = YES;
}

- (void) updateTotal
{
    CGFloat totalAmount = 0.0f;
    for (ItemInformation* itemInfo in _items) {
        NSInteger itemQuantity = [[_itemsCount objectForKey:itemInfo.barcode] integerValue];
        totalAmount += itemInfo.price*itemQuantity;
    }
    
    _footerView.totalLabel.text = [NSString stringWithFormat:@"%5.2f", totalAmount];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self updateTotal];
    shouldReloadCart = NO;

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
    return _items.count;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _cartHeader;
    //UIView *view = [UIView new];
    //view.frame = CGRectMake(0, 0, 320, 15);
    //view.backgroundColor = [UIColor blackColor];
    //return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _cartHeader.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell"];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = (CartCell*)[[[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    ItemInformation *itemInfo = _items[indexPath.row];
    NSUInteger itemsCount = [[_itemsCount objectForKey:itemInfo.barcode] unsignedIntegerValue];
    [cell setItemInfo:itemInfo quantity:itemsCount];
    cell.positionLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    //if (indexPath.row == _items.count - 1)
        cell.showBottomSeparator = YES;
    //else
      //  cell.showBottomSeparator = NO;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ItemInformation *itemInfo = _items[indexPath.row];
        
        [_items removeObjectAtIndex:indexPath.row];
        [_itemsCount removeObjectForKey:itemInfo.barcode];
        itemInfo = nil;
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self updateTotal];
    }
}

- (IBAction)clearCartAction:(id)sender
{
    if (_items.count < 1)
        return;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Вы действительно хотите очистить корзину?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да",nil];
    alert.tag = 0;
    [alert show];
}

- (IBAction)orderAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Отправить заказ?" delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да",nil];
    alert.tag = 1;
    [alert show];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _items = nil;
    _itemsCount = nil;
}

#pragma mark - Alert delegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            [_items removeAllObjects];
            [_itemsCount removeAllObjects];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self updateTotal];
        }
    }
    else
    {
        
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
