//
//  DiscountCartCell.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 24.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "DiscountCartCell.h"

@interface DiscountCartCell ()
{
    UIView *topView;
}

@end

@implementation DiscountCartCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib
{
    [super awakeFromNib];
     topView = self.titleLabel;
}

- (void) setItemInfo:(ItemInformation *)item quantity:(NSUInteger)quantity
{
    [super setItemInfo:item quantity:quantity];
    
    ParameterInformation* param = nil;
    ParameterInformation* quan  = nil;
    for (ParameterInformation *currentParam in item.additionalParameters) {
        if ([currentParam.name isEqualToString:@"discounts"])
            param = currentParam;
        if ([currentParam.name isEqualToString:@"quantity"])
            quan = currentParam;
    }
    
    NSUInteger realQuantity = quan ? [quan.value integerValue]:1;
    [super setItemInfo:item quantity:realQuantity];
    
    for (NSDictionary* currentDiscount in (NSArray*)param.value) {
        NSString *name   = [currentDiscount objectForKey:@"Номенклатура"];
        [self addDicsountField:name amount:[NSString stringWithFormat:@"%.2f", [[currentDiscount objectForKey:@"Сумма"] doubleValue]]];
    }
}

- (void) addDicsountField:(NSString*) name amount:(NSString*) amount
{
    
    //if (topView != self.titleLabel)
    //    return;
    
    UILabel* discountTitleLabel     = [UILabel new];
    UILabel* discountAmountLabel    = [UILabel new];
    
    discountTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    discountTitleLabel.numberOfLines = 0;
    discountTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [discountTitleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [discountTitleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    //[discountTitleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    //[discountTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [discountTitleLabel setTextColor:[UIColor redColor]];
    discountTitleLabel.text = name;
    [self.contentView addSubview:discountTitleLabel];
    
    discountAmountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [discountAmountLabel setTextColor:[UIColor redColor]];
    discountAmountLabel.text = amount;
    discountAmountLabel.textAlignment = NSTextAlignmentRight;
    [discountAmountLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [discountAmountLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:discountAmountLabel];
    
    
    
    [self.contentView removeConstraint:self.bottomConstraint];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountTitleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountTitleLabel
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:36.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountTitleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:topView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:8.0]];
    self.bottomConstraint = [NSLayoutConstraint constraintWithItem:discountTitleLabel
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:-8.0];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountTitleLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:21.0]];
    
    [self.contentView addConstraint:self.bottomConstraint];
    topView = discountTitleLabel;
    
    // Amount Label
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountAmountLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.priceLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountAmountLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.priceLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountAmountLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:discountTitleLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountAmountLabel
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0
                                                                  constant:21.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountAmountLabel
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:discountTitleLabel
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:7.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:discountAmountLabel
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:discountAmountLabel.superview
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:-15.0]];
    
    
    
}


@end
