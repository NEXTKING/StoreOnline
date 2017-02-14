//
//  MelonPriceTag29x28.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 30/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonLabel29x28.h"
#import "BarCodeView.h"

@implementation MelonLabel29x28

- (void)setItemInformation:(ItemInformation *)item
{
    [super setItemInformation:item];
    self.materialLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Состав", nil), item.material];
}

@end
