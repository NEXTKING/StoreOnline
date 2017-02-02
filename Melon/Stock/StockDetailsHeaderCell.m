//
//  StockDetailsHeaderCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 01/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "StockDetailsHeaderCell.h"
#import "AppAppearance.h"

@implementation StockDetailsHeaderCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = AppAppearance.sharedApperance.tableViewSectionHeaderBackgroundColor;
    self.sizeLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Font;
    self.sizeLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle1Color;
    self.countLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle2Font;
    self.countLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle2Color;
    self.countTitleLabel.font = AppAppearance.sharedApperance.tableViewSectionHeaderTitle3Font;
    self.countTitleLabel.textColor = AppAppearance.sharedApperance.tableViewSectionHeaderTitle3Color;
    self.countTitleLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"Количество", nil)];
}

@end
