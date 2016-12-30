//
//  ClaimItemCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcceptancesProtocol.h"

@interface ClaimItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *claimNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomingDateLabel;

- (void)configureWithAcceptanceItem:(id<AcceptancesItem>)item;

@end
