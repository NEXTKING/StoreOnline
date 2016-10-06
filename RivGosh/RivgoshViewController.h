//
//  RivgoshViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 22.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartViewController.h"
#import "DesondoButton.h"
#import "MCPServer.h"

@interface RivgoshViewController : CartViewController <UITableViewDelegate, UITableViewDataSource, ItemDescriptionDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *headerActivity;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *footerActivity;
@property (weak, nonatomic) IBOutlet DesondoButton *nextButton;
@property (weak, nonatomic) IBOutlet DesondoButton *clearButton;

- (void) requestItemInformation:(NSString*) code;


@end
