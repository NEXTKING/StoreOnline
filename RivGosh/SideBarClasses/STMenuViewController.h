//
//  STMenuViewController.h
//  MobileBanking
//
//  Created by Kurochkin on 20/01/14.
//  Copyright (c) 2014 BPC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSPF_Workspace.h"
#import "STMenuDataSource.h"

@interface STMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    @protected
    NSMutableArray *_itemsMyBanking;
    NSMutableArray *_itemsTools;
    int _itemsRowHeight;
}

//@property (assign, nonatomic) id <SimpleTableItemsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableViewCell *menuCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *layoutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstraint;

@property (strong, nonatomic) STMenuDataSource *menuDataSource;


@end
