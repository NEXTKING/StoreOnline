//
//  MelonPriceTag48x48.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 30/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonPriceTag48x48.h"

@implementation MelonPriceTag48x48

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
