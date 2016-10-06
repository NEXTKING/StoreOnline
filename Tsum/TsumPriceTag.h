//
//  TsumPriceTag.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 14.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AntiAliasView.h"
#import "AntiAliasingLabel.h"
#import "ItemInformation.h"

@interface TsumPriceTag : UIView

- (void) setItemInformation:(ItemInformation*) item;
@property (weak, nonatomic) IBOutlet AntiAliasView *barocdeImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barcodeWidthConstraint;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *barcodeTextField;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *nameLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *sizeLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *brandLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *countryLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *articleLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *dateLabel;
@property (weak, nonatomic) IBOutlet AntiAliasingLabel *priceLabel;

@end
