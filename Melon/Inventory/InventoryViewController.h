//
//  InventoryViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 28.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "RivgoshViewController.h"
#import "InventorySectionsViewController.h"

@interface InventoryViewController : RivgoshViewController

@property (weak, nonatomic) IBOutlet UIView *shieldView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) SectionDescription* section;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;

@end
