//
//  ReceivesListCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ReceivesListCell.h"
#import "AppAppearance.h"

@implementation ReceivesListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
    
    _titleLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _titleLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _positionLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    self.accessoryView = AppAppearance.sharedApperance.tableViewCellDisclosureIndicatorView;
    self.accessoryView.frame = AppAppearance.sharedApperance.tableViewCellDisclosureIndicatorViewFrame;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
