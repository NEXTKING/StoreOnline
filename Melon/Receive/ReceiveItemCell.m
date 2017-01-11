//
//  ReceiveItemCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ReceiveItemCell.h"
#import "AppAppearance.h"

@implementation ReceiveItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
    
    _titleLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _titleLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _quantityLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _quantityLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    _barcodeLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _barcodeLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _positionLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
}

- (void)setExcessStyle
{
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundRedColor;
}

- (void)setCompleteStyle
{
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundGreenColor;
}

- (void)setDefaultStyle
{
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
}

@end
