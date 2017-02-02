//
//  StockDetailsHeaderCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 01/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockDetailsHeaderCell : UITableViewHeaderFooterView

@property (nonatomic, weak) IBOutlet UILabel *sizeLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *countTitleLabel;

@end
