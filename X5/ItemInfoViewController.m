//
//  ItemInfoViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 05/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ItemInfoViewController.h"

@interface ItemInfoViewController ()

@end

@implementation ItemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cashDeskPrice.text = @"";
    _reserveLabel.text = @"";
    _unitLabel.text = @"";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateItemInfo:(ItemInformation *)itemInfo
{
    [super updateItemInfo:itemInfo];
    
    if (!itemInfo)
    {
        _cashDeskPrice.text = @"";
        _reserveLabel.text = @"";
        _unitLabel.text = @"";
        return;
    }
    
    _unitLabel.text = itemInfo.unit;
    
    ParameterInformation *reserveParam = nil;
    ParameterInformation *cashDeskParam = nil;
    for (ParameterInformation* currentParam in itemInfo.additionalParameters) {
        if ([currentParam.name isEqualToString:@"Запас"])
            reserveParam = currentParam;
        
        if ([currentParam.name isEqualToString:@"Цена на кассе"])
           cashDeskParam = currentParam;
    }
    
    _reserveLabel.text = reserveParam.value;
    _cashDeskPrice.text = [NSString stringWithFormat:@"%.2f",cashDeskParam.value.doubleValue];
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
