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
    
    _manufactureDateLabel.text = @"Дата изгот.: 17.12.2016";
    _manufactureLabel.text = @"Изготовитель: Китай Сумек текстиле инстастриал";
}

@end
