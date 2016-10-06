//
//  PreviewViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 24.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *proceedActivity;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalAmountLabel;
@property (copy, nonatomic) NSString *receiptID;

@property (nonatomic, strong) NSArray* items;

@end
