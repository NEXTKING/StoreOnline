//
//  PaymentViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 31.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController

@property (nonatomic, copy) NSString* amount;
@property (nonatomic, copy) NSString* receiptId;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *slipLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiscalLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;
@property (weak, nonatomic) IBOutlet UIButton *slipButton;
@property (weak, nonatomic) IBOutlet UIButton *fiscalButton;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIButton *restartPayment;
@property (weak, nonatomic) IBOutlet UIView *transactionSuccessView;


@end
