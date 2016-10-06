//
//  DiscountsViewController.h
//  PriceTagDemo
//
//  Created by denis on 12.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPServer.h"
#import "PreviewViewController.h"
#import "DesondoButton.h"

@interface DiscountsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<DiscountInformation*>* discounts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalAmountLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *proceedActivityIndicator;
@property (strong, nonatomic) IBOutlet UIToolbar *accessoryToolbar;

@property (assign, nonatomic) double amount;
@property (copy, nonatomic) NSString* receiptID;
@property (weak, nonatomic) IBOutlet DesondoButton *nextButton;

@end
