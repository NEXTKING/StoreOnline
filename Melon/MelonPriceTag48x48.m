//
//  MelonPriceTag48x48.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 30/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonPriceTag48x48.h"

@implementation MelonPriceTag48x48

- (void) setItemInformation:(ItemInformation*) item
{
    [super setItemInformation:item];
    
    _nameLabel.text = item.name;
    _articleLabel.text = item.article;
    _colorLabel.text = item.color;
    
    _sizeLabel.text = @"170-88-96 S";
    _manufactureDateLabel.text = @"Дата изгот.: 17.12.2016";
    _manufactureLabel.text = @"Изготовитель: Китай Сумек текстиле инстастриал";
}

@end
