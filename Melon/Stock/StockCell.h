//
//  StockCell.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 30/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stocksLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;

@end
