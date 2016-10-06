//
//  StockDescriptionController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "StockDescriptionController.h"
#import "WarehouseInformation.h"

@interface StockDescriptionController ()

@end

@implementation StockDescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemNameLabel.text     = _item.name;
    _itemArticleLabel.text  = [NSString stringWithFormat:@"Артикул: %@", _item.article];
    
    if (_item.warehouses.count > 0)
    {
        WarehouseInformation* warehouse = _item.warehouses[0];
        _wh1Title.text = warehouse.name;
        _inStockLabel1.text = [NSString stringWithFormat:@"%d", warehouse.count];
        _reserveLabel1.text = [NSString stringWithFormat:@"%d", warehouse.reservedCount];
    }
    if (_item.warehouses.count > 1)
    {
        WarehouseInformation* warehouse = _item.warehouses[1];
        _wh2Title.text = warehouse.name;
        _inStockLabel2.text = [NSString stringWithFormat:@"%d", warehouse.count];
        _reserveLabel2.text = [NSString stringWithFormat:@"%d", warehouse.reservedCount];
    }
    if (_item.warehouses.count > 2)
    {
        WarehouseInformation* warehouse = _item.warehouses[2];
        _wh3Title.text = warehouse.name;
        _inStockLabel3.text = [NSString stringWithFormat:@"%d", warehouse.count];
        _reserveLabel3.text = [NSString stringWithFormat:@"%d", warehouse.reservedCount];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
