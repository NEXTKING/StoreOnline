//
//  StockDetailsCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 01/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;

@end
