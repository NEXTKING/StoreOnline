//
//  MelonLabel.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "MelonPriceTag.h"

@interface MelonLabel : MelonPriceTag

@property (weak, nonatomic) IBOutlet UILabel *manufactureDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufactureLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *importerLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *localizedLabels;
@end
