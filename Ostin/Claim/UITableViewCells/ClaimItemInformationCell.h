//
//  ClaimItemInformationCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptancesProtocol.h"

typedef void (^ImageTapBlock) (void);

@interface ClaimItemInformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelReasonLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeCancelReasonButton;

@property (assign, nonatomic) BOOL zoomEnabled;
@property (copy, nonatomic) ImageTapBlock actionBlock;

- (void)configureWithAcceptanceItem:(id<AcceptancesItem>)item cancelButtonEnabled:(BOOL)enabled;
@end
