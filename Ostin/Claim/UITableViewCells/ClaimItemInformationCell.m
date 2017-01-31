//
//  ClaimItemInformationCell.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ClaimItemInformationCell.h"
#import "AsyncImageView.h"

@implementation ClaimItemInformationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImage *image = [[UIImage imageNamed:@"icon_pencil"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_changeCancelReasonButton setImage:image forState:UIControlStateNormal];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [_pictureImageView addGestureRecognizer:tapGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithAcceptanceItem:(id<AcceptancesItem>)item cancelButtonEnabled:(BOOL)enabled
{
    _articleLabel.text = [item descriptionForKey:@"articleDescription"];
    _priceLabel.text = [item descriptionForKey:@"priceDescription"];
    _titleLabel.text = [item descriptionForKey:@"title"];
    _countLabel.text = [item descriptionForKey:@"countDescription"];
    _cancelReasonLabel.text = [item descriptionForKey:@"cancelReasonDescription"];
    _pictureImageView.image = [UIImage imageNamed:@"no-image.png"];
    
    
    _changeCancelReasonButton.tintColor = enabled ? [UIColor colorWithRed:0 green:82/255.0 blue:1 alpha:1] : [UIColor lightGrayColor];
    _changeCancelReasonButton.enabled = enabled;
    _cancelReasonLabel.textColor = enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
    self.backgroundColor = (item.scannedCount < item.totalCount) ? [UIColor whiteColor] : [UIColor colorWithRed:126/255.0 green:211/255.0 blue:33/255.0 alpha:0.2];
    
    if (!(item.scannedCount < item.totalCount))
    {
        _changeCancelReasonButton.hidden = YES;
        _changeCancelReasonButton.enabled = NO;
    }
    else
    {
        _changeCancelReasonButton.hidden = NO;
    }
}

- (IBAction)tapGestureAction:(id)sender
{
    if (_actionBlock && _zoomEnabled)
        _actionBlock();
}

@end
