//
//  MelonPriceTag.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 28.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInformation.h"
#import "AntiAliasView.h"

@interface MelonPriceTag : UIView

- (void) setItemInformation:(ItemInformation*) item;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *barcodeView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eacImage;

@end
