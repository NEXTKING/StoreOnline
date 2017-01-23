//
//  CartCell.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInformation.h"
#import "DPStepper.h"

@interface CartCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (assign, nonatomic) BOOL showBottomSeparator;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet DPStepper *stepper;

- (void) setItemInfo:(nullable ItemInformation*) item quantity:(NSUInteger) quantity;

@end
