//
//  OstinPriceTag.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 29.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInformation.h"
#import "AntiAliasView.h"
#import "AntiAliasingLabel.h"

@interface OstinPriceTag : UIView

- (void) setItemInformation:(ItemInformation*) item;
@property (weak, nonatomic) IBOutlet AntiAliasView *barocdeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barcodeWidthConstraint;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *priceLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *nameLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *bigSizeLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *smallSizeLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *articleLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *dropLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *shopCodeLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *dateLabel;

@end
