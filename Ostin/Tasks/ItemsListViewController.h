//
//  ItemsListViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 22/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsListViewController : UITableViewController

@property (nonatomic, assign) BOOL tasksMode;
@property (nonatomic, strong) NSDictionary *fakeData;
@end
