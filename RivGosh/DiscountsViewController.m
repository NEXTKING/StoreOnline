//
//  DiscountsViewController.m
//  PriceTagDemo
//
//  Created by denis on 12.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "DiscountsViewController.h"
#import "MCPServer.h"
#import "DiscountTitleCell.h"

@interface DiscountsViewController () <UITextFieldDelegate, ApplyDiscountsDelegate>
{
    NSArray* previewItems;
}

@end

@implementation DiscountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _amountLabel.text = [NSString stringWithFormat:@"%.2f", _amount];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self updateTotal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(_discounts.count, 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_discounts.count == 0)
        return 0;
    return 5;
}

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (_discounts.count == 0)
        return @"Нет доступных скидок";
    else
        return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"DiscountCellIdentifier";
    static NSString* TitleCellIdentifier = @"DiscountTitleCellIdentifier";
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0)
        [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier];
    else
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        if (indexPath.row == 0)
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscountTitleCell" owner:nil options:nil] objectAtIndex:0];
        else
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    DiscountInformation* discount = _discounts[indexPath.section];
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell viewWithTag:999] removeFromSuperview];
    
    switch (indexPath.row) {
        case 0:
        {
            DiscountTitleCell* discountCell = (DiscountTitleCell*)cell;
            discountCell.nameLabel.text = discount.name;
            discountCell.toggleSwitch.on = discount.enabled;
            discountCell.toggleSwitch.tag = indexPath.section;
            [discountCell.toggleSwitch removeTarget:nil
                                             action:NULL
                                   forControlEvents:UIControlEventAllEvents];
            [discountCell.toggleSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        }
            break;
        case 1:
            cell.textLabel.text = @"Количество";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", discount.count];
            break;
        case 2:
            cell.textLabel.text = @"Макс. скидка";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", discount.maxDiscount];
            break;
        case 3:
            cell.textLabel.text = @"Сумма скидки, руб";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", discount.discountAmountRub];
            if (discount.editable)
            {
                if (discount.enabled)
                {
                    [self addTextFieldToCell:cell withIndexPath:indexPath];
                }
                cell.detailTextLabel.text = @" ";
            }
            else
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", discount.discountAmountRub];
            break;
        case 4:
            cell.textLabel.text = @"Сумма скидки, баллы";
            if (discount.enabled)
            {
                NSInteger points = ceil(discount.count/discount.maxDiscount*discount.discountAmountRub);
                discount.discountAmountPoints = points;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f", discount.discountAmountPoints];
            }
            else
                cell.detailTextLabel.text = @" ";
                
            break;
            
        default:
            break;
    }

    // Configure the cell...
    
    return cell;
}

- (void) addTextFieldToCell:(UITableViewCell*) cell withIndexPath:(NSIndexPath*) indexPath
{
    DiscountInformation* discount = _discounts[indexPath.section];
    
    UITextField* textField = [[UITextField alloc] init];
    textField.tag = 999;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:textField];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:8]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:8]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-8]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.detailTextLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    textField.textAlignment = NSTextAlignmentRight;
    textField.text = [NSString stringWithFormat:@"%.0f", discount.discountAmountRub];
    //textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.inputAccessoryView = _accessoryToolbar;
}

- (void) switchAction:(UISwitch*) sender
{
    DiscountInformation* discount = _discounts[sender.tag];
    discount.enabled = sender.on;
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = 1; i < 5; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self updateTotal];
}

- (void) updateTotal
{
    double discountAmount = 0.0;
    for (DiscountInformation* discount in _discounts) {
        if (discount.enabled)
            discountAmount+=discount.discountAmountRub;
    }
    
    _discountAmountLabel.text = [NSString stringWithFormat:@"%.2f", discountAmount];
    _finalAmountLabel.text = [NSString stringWithFormat:@"%.2f", _amount - discountAmount];
}

#pragma mark - TextField Delegate

- (IBAction)hideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    NSNumber* currentAmount = [numberFormatter numberFromString:textField.text];
    
    UIView* view = textField;
    NSIndexPath *indexPath = nil;
    while (view.superview) {
        if ([view isKindOfClass:[UITableViewCell class]])
        {
            indexPath = [self.tableView indexPathForCell:(UITableViewCell*)view];
            break;
        }
        view = view.superview;
    }
    
    DiscountInformation* discount = _discounts[indexPath.section];
    double finalDiscount = MAX(MIN(discount.maxDiscount, currentAmount.doubleValue), 0);
    currentAmount = [NSNumber numberWithDouble:finalDiscount];
    
    discount.discountAmountRub = currentAmount.doubleValue;
    
    textField.text = [NSString stringWithFormat:@"%.0f", currentAmount.doubleValue];
    
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = 3; i < 5; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self updateTotal];
    
}

- (IBAction)applyDiscountsAction:(id)sender
{
    [_proceedActivityIndicator startAnimating];
    _nextButton.enabled = NO;
    [[MCPServer instance] applyDiscounts:self discounts:_discounts receiptId:_receiptID];
}

- (void) applyDiscountsComplete:(int)result items:(NSArray *)items
{
 
    _nextButton.enabled = YES;
    [_proceedActivityIndicator stopAnimating];
    if (result == 0)
    {
        previewItems = items;
        [self performSegueWithIdentifier:@"PreviewSegue" sender:nil];
    }
    else
    {
        NSString* errorDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkErrorDescription"];
        NSString* message = errorDescription?errorDescription:@"Не удалось применить скидки";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PreviewViewController *previewVC = segue.destinationViewController;
    previewVC.items = previewItems;
    previewVC.receiptID = _receiptID;
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
