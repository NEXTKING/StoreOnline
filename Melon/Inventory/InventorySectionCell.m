//
//  InventorySectionCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "InventorySectionCell.h"
#import "AppAppearance.h"

@implementation InventorySectionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _titleLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _titleLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _barcodeLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _barcodeLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _positionLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    self.accessoryView = AppAppearance.sharedApperance.tableViewCellDisclosureIndicatorView;
    self.accessoryView.frame = AppAppearance.sharedApperance.tableViewCellDisclosureIndicatorViewFrame;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

//    if (selected)
//    {
//        self.backgroundColor = AppAppearance.sharedApperance.tableViewCellSelectedBackgroundColor;
//        
//        _titleLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1SelectedColor;
//        _barcodeLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2SelectedColor;
//        _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2SelectedColor;
//    }
//    else
//    {
//        self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
//        
//        _titleLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
//        _barcodeLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
//        _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
//    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

@end
