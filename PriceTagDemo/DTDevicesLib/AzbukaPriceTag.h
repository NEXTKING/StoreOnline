//
//  AzbukaPriceTag.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 04.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AntiAliasingLabel.h"
#import "AntiAliasView.h"
#import "ItemInformation.h"

@interface AzbukaPriceTag : UIView

@property (weak, nonatomic) IBOutlet AntiAliasingLabel *nameLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *priceLabel;
@property (weak, nonatomic) IBOutlet AntiAliasView *barcodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barcodeWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *discountImage;

- (void) setItem: (ItemInformation*) item;


@end
