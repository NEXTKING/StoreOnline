//
//  MelonPriceTag30x60.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 25/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonPriceTag30x60.h"
#import "BarCodeView.h"

@implementation MelonPriceTag30x60

- (void)setItemInformation:(ItemInformation *)item
{
    [super setItemInformation:item];
    
    ParameterInformation *firstPriceParam = nil;
    for (ParameterInformation* currentParam in item.additionalParameters)
    {
        if ([currentParam.name isEqualToString:@"FirstPrice"])
            firstPriceParam = currentParam;
    }
    
    if (firstPriceParam)
        self.priceLabel.text = [NSString stringWithFormat:@"Цена: %@р.", firstPriceParam.value];
}

@end
