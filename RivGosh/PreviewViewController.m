//
//  PreviewViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 24.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "PreviewViewController.h"
#import "DiscountCartCell.h"
#import "ItemInformation.h"
#import "PaymentViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    CGFloat totalAmount   = 0.0f;
    CGFloat totalDiscount = 0.0f;
    for (ItemInformation *item in _items) {
        
        ParameterInformation* param = nil;
        ParameterInformation* quan  = nil;
        
        for (ParameterInformation *currentParam in item.additionalParameters) {
            if ([currentParam.name isEqualToString:@"discounts"])
                param = currentParam;
            if ([currentParam.name isEqualToString:@"quantity"])
                quan = currentParam;
        }
        
        for (NSDictionary* currentDiscount in (NSArray*)param.value) {
            totalDiscount += [[currentDiscount objectForKey:@"Сумма"] doubleValue];
        }
        
        totalAmount += item.price*[quan.value integerValue];
        
    }
    
    _totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", totalAmount];
    _totalDiscountLabel.text = [NSString stringWithFormat:@"%.2f", totalDiscount];
    _finalAmountLabel.text = [NSString stringWithFormat:@"%.2f", totalAmount+totalDiscount];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscountCartCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DiscountCartCell"];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DiscountCartCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    ItemInformation* item = _items[indexPath.row];
    [cell setItemInfo:item quantity:1];
    cell.showBottomSeparator = YES;
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    PaymentViewController* paymentVC = segue.destinationViewController;
    paymentVC.amount = _finalAmountLabel.text;
    paymentVC.receiptId = _receiptID;
}


@end
