//
//  ViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21.01.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCPServer.h"
#import "DTDevices.h"

@interface ViewController : UIViewController <DTDeviceDelegate,ItemDescriptionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *printButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemArticleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (nonatomic, strong) ItemInformation* currentItemInfo;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (nonatomic, assign) NSInteger numberOfCopies;
@property (assign, nonatomic) BOOL shouldRetrack;

- (void) requestItemInfoWithCode:(NSString*) code;
- (void) updateItemInfo:(ItemInformation*) itemInfo;
- (void) clearInfo;
- (void) amountCompareCompleted:(BOOL) isEqual;

- (void) startLoadingImage:(NSString*) imageName;
- (void) imageLoaded:(UIImage*) image;
- (void) showInfoMessage:(NSString*) info;
- (IBAction)leftButtonAction:(id)sender;
- (IBAction)calibrateAction:(id)sender;
- (IBAction)printButtonAction:(id)sender;
- (IBAction)retractAction:(id)sender;

@end

