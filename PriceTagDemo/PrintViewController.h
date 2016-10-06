//
//  PrintViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21.01.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemInformation.h"
#import "AntiAliasView.h"

@protocol PrinterControllerDelegate <NSObject>

- (void) printerDidFinishPrinting;
- (void) printerDidFailPrinting:(NSError*)error;

@end

@interface PrintViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id<PrinterControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *receiptView;
@property (weak, nonatomic) IBOutlet AntiAliasView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptBarcodeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *barcodeWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *barcodeView;
@property (assign, nonatomic) BOOL shouldRetrack;

- (void) startSearchingPtinter;
- (void) stopSearchingPrinter;
- (void) print:(ItemInformation *)itemInfo copies:(NSInteger) copies;
- (void) calibrate;
- (void) temporaryFeed;

@end
