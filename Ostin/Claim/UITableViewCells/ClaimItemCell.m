//
//  ClaimItemCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ClaimItemCell.h"

@implementation ClaimItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithAcceptanceItem:(id<AcceptancesItem>)item
{
    _claimNumberLabel.text = [item descriptionForKey:@"claimNumber"];
    _statusLabel.text = [item descriptionForKey:@"statusDescription"];
    _remainTimeLabel.text = [item descriptionForKey:@"remainTimeDescription"];
    _incomingDateLabel.text = [item descriptionForKey:@"incomingDateDescription"];
}

@end
