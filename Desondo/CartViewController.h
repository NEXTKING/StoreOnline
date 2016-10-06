//
//  CartViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartFooterView.h"

@interface CartViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet CartFooterView *footerView;
@property (nonatomic, strong)  NSMutableArray* items;
@property (nonatomic, strong)  NSMutableDictionary*itemsCount;
@property (strong, nonatomic) IBOutlet UIView *cartHeader;
- (void) cartAddHandler:(NSNotification*) aNotification;
- (void) updateTotal;

@end
