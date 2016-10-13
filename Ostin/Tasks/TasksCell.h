//
//  TasksCell.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 13/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
