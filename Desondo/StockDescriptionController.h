//
//  StockDescriptionController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInformation.h"

@interface StockDescriptionController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemArticleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wh1Title;
@property (weak, nonatomic) IBOutlet UILabel *wh2Title;
@property (weak, nonatomic) IBOutlet UILabel *wh3Title;

@property (weak, nonatomic) IBOutlet UILabel *inStockLabel1;
@property (weak, nonatomic) IBOutlet UILabel *reserveLabel1;
@property (weak, nonatomic) IBOutlet UILabel *inStockLabel2;
@property (weak, nonatomic) IBOutlet UILabel *reserveLabel2;
@property (weak, nonatomic) IBOutlet UILabel *inStockLabel3;
@property (weak, nonatomic) IBOutlet UILabel *reserveLabel3;

@property (strong, nonatomic) ItemInformation* item;

@end
