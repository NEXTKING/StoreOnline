//
//  InventorySectionCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventorySectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@end
