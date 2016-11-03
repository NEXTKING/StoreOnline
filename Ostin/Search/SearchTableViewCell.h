//
//  SearchTableViewCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 10/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemCodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@end
