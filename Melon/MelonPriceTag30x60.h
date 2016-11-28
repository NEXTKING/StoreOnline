//
//  MelonPriceTag30x60.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 25/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MelonPriceTag.h"

@interface MelonPriceTag30x60 : MelonPriceTag

@property (weak, nonatomic) IBOutlet UILabel *manufactureDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufactureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end
