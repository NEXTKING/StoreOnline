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
    
    _sizeLabel.text = @"170-88-96 S";
    _manufactureDateLabel.text = @"17.12.2016";
    _manufactureLabel.text = @"Изготовитель: Китай Сумек текстиле инстастриал";
}

@end
