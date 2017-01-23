//
//  CartCell.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "CartCell.h"
#import "AppAppearance.h"

@interface CartCell ()
@end

@implementation CartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = AppAppearance.sharedApperance.tableViewCellBackgroundColor;
    
    _titleLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
    _titleLabel.font = AppAppearance.sharedApperance.tableViewCellTitle1Font;
    
    _descriptionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _descriptionLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    _barcodeLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _barcodeLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
    
    _positionLabel.textColor = AppAppearance.sharedApperance.tableViewCellTitle2Color;
    _positionLabel.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setItemInfo:(ItemInformation *)item quantity:(NSUInteger)quantity
{
    if (!item)
    {
        _priceLabel.text = @"";
        _titleLabel.text = @"";
        _descriptionLabel.text = @"";
        
        return;
    }
    
  
    _titleLabel.text = item.name;
    
    _descriptionLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Арт.", nil), item.article?item.article:@""];
    _barcodeLabel.text = item.barcode;
    [_stepper setValue:quantity];
}

- (IBAction)stepperAction:(UIStepper*)sender
{
    
}



@end
