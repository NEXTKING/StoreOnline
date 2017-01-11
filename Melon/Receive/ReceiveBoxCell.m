//
//  ReceiveBoxCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ReceiveBoxCell.h"
#import "AppAppearance.h"

@implementation ReceiveBoxCell

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
    
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
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
