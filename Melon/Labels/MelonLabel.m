//
//  MelonLabel.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 09/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "MelonLabel.h"
#import "BarCodeView.h"

@implementation MelonLabel

- (void)setItemInformation:(ItemInformation *)item
{
    for (UILabel *label in self.localizedLabels)
    {
        if ([label.text hasSuffix:@":"])
        {
            NSString *text = [label.text substringToIndex:label.text.length - 1];
            label.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(text, nil)];
        }
        else
            label.text = NSLocalizedString(label.text, nil);
    }
    
    if (_nameLabel)
    {
        _nameLabel.text = item.name;
    }
    
    if (_articleLabel)
    {
        _articleLabel.text = item.article;
    }
    
    if (_manufactureLabel)
    {
        NSString *manufacturerParam = nil;
        
        for (ParameterInformation* currentParam in item.additionalParameters)
        {
            if ([currentParam.name isEqualToString:@"Manufacturer"])
                manufacturerParam = currentParam.value;
        }
        _manufactureLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Изготовитель", nil), manufacturerParam ? manufacturerParam : @""];
    }
    
    if (_manufactureDateLabel)
    {
        NSString *manufactureDateParam = nil;
        
        for (ParameterInformation* currentParam in item.additionalParameters)
        {
            if ([currentParam.name isEqualToString:@"ProductionDate"])
                manufactureDateParam = currentParam.value;
        }
        
        _manufactureDateLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Дата изгот.", nil), manufactureDateParam ? [manufactureDateParam stringByReplacingOccurrencesOfString:@" 0:00:00" withString:@""] : @""];
    }
    
    NSString *color = @"";
    NSString *size1 = @"";
    NSString *size2 = @"";
    
    for (ParameterInformation* currentParam in item.additionalParameters)
    {
        if ([currentParam.name isEqualToString:@"Описание"])
        {
            NSString *string = currentParam.value;
            NSRange searchedRange = NSMakeRange(0, [string length]);
//            NSString *pattern = @".* арт\\..* цв\\.(.*) р-р\\.(.*) р\\.(.*)";
            NSString *pattern = @".*\\.(.*) .*\\.(.*) .*\\.(.*)";
            
            NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range: searchedRange];
            color = [string substringWithRange:[match rangeAtIndex:1]];
            size1 = [string substringWithRange:[match rangeAtIndex:2]];
            size2 = [string substringWithRange:[match rangeAtIndex:3]];
            
            break;
        }
    }
    
    if (_colorLabel)
    {
        _colorLabel.text = color;
    }
    
    if (_sizeLabel)
    {
        ParameterInformation *sizeParam = nil;
        
        for (ParameterInformation* currentParam in item.additionalParameters)
        {
            if ([currentParam.name isEqualToString:@"Size"])
                sizeParam = currentParam;
        }
        
        if (sizeParam)
            _sizeLabel.text = sizeParam.value;
        else
            _sizeLabel.text = @"";
    }
    
    if (_importerLabel)
    {
        ParameterInformation *importerParam = nil;
        
        for (ParameterInformation* currentParam in item.additionalParameters)
        {
            if ([currentParam.name isEqualToString:@"Importer"])
                importerParam = currentParam;
        }
        
        _importerLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Импортер", nil), importerParam ? importerParam.value : @""];
    }
    
    if (_materialLabel)
    {
        _materialLabel.text = item.material;
    }
    
    ParameterInformation *firstPriceParam = nil;
    for (ParameterInformation* currentParam in item.additionalParameters)
    {
        if ([currentParam.name isEqualToString:@"FirstPrice"])
            firstPriceParam = currentParam;
    }
    
    if (firstPriceParam)
        self.priceLabel.text = [NSString stringWithFormat:@"%@: %@%@", NSLocalizedString(@"Цена", nil), firstPriceParam.value, NSLocalizedString(@"р.", nil)];
    
    [self.barcodeView setHidden:NO];
    BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:CGRectMake(0, 0, self.barcodeView.frame.size.width, self.barcodeView.frame.size.height)];
    [self.barcodeView addSubview:barCodeView];
    [barCodeView setBarCode:item.barcode];
    [self.barcodeView setNeedsDisplay];
}

@end
