//
//  DesondoProductController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ViewController.h"

@interface DesondoProductController : ViewController
@property (weak, nonatomic) IBOutlet UIView *temporaryView;

//Item description

@property (weak, nonatomic) IBOutlet UILabel *itamMaterialLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemWidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDiameterLabel;
@property (weak, nonatomic) IBOutlet UILabel *inStockLabel;
@property (weak, nonatomic) IBOutlet UILabel *reseverdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingIndicator;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *imageGestureRecognizer;



@end
