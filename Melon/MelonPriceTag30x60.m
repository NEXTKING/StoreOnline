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

- (void) setItemInformation:(ItemInformation*) item
{
    [super setItemInformation:item];
    
    _nameLabel.text = item.name;
    _articleLabel.text = item.article;
    _colorLabel.text = item.color;
    
    _sizeLabel.text = @"";
    
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
