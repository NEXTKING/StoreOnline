//
//  StockDetailsCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 01/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "StockDetailsCell.h"
#import "AppAppearance.h"

@implementation StockDetailsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
    
    _colorLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _colorLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _stockLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _stockLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _positionLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
}


@end
