//
//  StockCell.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 30/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "StockCell.h"
#import "AppAppearance.h"

@implementation StockCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
    
    _nameLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _nameLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _articleLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _articleLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    _stockLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _stockLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _positionLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
}

@end
