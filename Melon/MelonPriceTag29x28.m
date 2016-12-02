//
//  MelonPriceTag29x28.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 30/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonPriceTag29x28.h"

@implementation MelonPriceTag29x28

- (void) setItemInformation:(ItemInformation*) item
{
    [super setItemInformation:item];
    
    _nameLabel.text = item.name;
    _articleLabel.text = item.article;
    _colorLabel.text = item.color;
    
    ParameterInformation *manufacturerParam = nil;
    ParameterInformation *manufactureDateParam = nil;
    
    for (ParameterInformation* currentParam in item.additionalParameters) {
        if ([currentParam.name isEqualToString:@"Manufacturer"])
            manufacturerParam = currentParam;
        
        if ([currentParam.name isEqualToString:@"ManufactureDate"])
            manufactureDateParam = currentParam;
    }
    _manufactureDateLabel.text = manufactureDateParam ? [NSString stringWithFormat:@"Дата изгот.: %@", manufactureDateParam.value] : @"Дата изгот.:";
    _manufactureLabel.text = manufacturerParam ? [NSString stringWithFormat:@"Изготовитель: %@", manufacturerParam.value] : @"Изготовитель:";
}

@end
