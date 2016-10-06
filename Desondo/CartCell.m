//
//  CartCell.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "CartCell.h"

@interface CartCell ()
{
    CALayer *topBorder;
    CALayer *bottomBorder;
}

@end

@implementation CartCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //topBorder = [CALayer layer];
    //topBorder.backgroundColor = [UIColor blackColor].CGColor;
    //[self.layer addSublayer:topBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:bottomBorder];
    bottomBorder.hidden = YES;
}

- (void) layoutSubviews
{
    topBorder.frame = CGRectMake(20, 0, self.frame.size.width-40, 1);
    bottomBorder.hidden = !_showBottomSeparator;
    bottomBorder.frame = CGRectMake(20, self.frame.size.height-1, self.frame.size.width-40, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    if (quantity > 1)
        _titleLabel.text = [NSString stringWithFormat:@"%@ (x%lu)", item.name, (unsigned long)quantity];
    else
        _titleLabel.text = item.name;
    
    _descriptionLabel.text = item.article;
    _priceLabel.text = [NSString stringWithFormat:@"%.2f", item.price*quantity];
}


@end
