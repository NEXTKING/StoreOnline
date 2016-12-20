//
//  MelonPriceTag.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 28.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonPriceTag.h"
#import "BarCodeView.h"

@implementation MelonPriceTag

- (void) setItemInformation:(ItemInformation*) item
{
    [self layoutIfNeeded];
    
    if (_priceLabel)
    {
        _priceLabel.text = [NSString stringWithFormat:@"Цена: %.0fр.", item.price];
    }
    
    if (_dateLabel)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        _dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
//    }
//    
//    if (_oldPriceLabel)
//    {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"0 р."];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        _oldPriceLabel.attributedText = attributeString;
        [self addOldPriceIfNeeded:item];
    }
    
    BOOL shouldPrintBarcode = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldPrintBarcode"];
    
    if (!shouldPrintBarcode)
    {
        _barcodeLabel.hidden = YES;
        _barcodeView.hidden = YES;
    }
    else
    {
        _barcodeLabel.text = item.barcode;
        BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:CGRectMake(0, 0, _barcodeView.frame.size.width, _barcodeView.frame.size.height)];
        [_barcodeView addSubview:barCodeView];
        [barCodeView setBarCode:item.barcode];

        [_barcodeView setNeedsDisplay];
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
        ParameterInformation *manufacturerParam = nil;
        
        for (ParameterInformation* currentParam in item.additionalParameters)
        {
            if ([currentParam.name isEqualToString:@"Manufacturer"])
                manufacturerParam = currentParam;
        }
        _manufactureLabel.text = manufacturerParam ? [NSString stringWithFormat:@"Изготовитель: %@", manufacturerParam.value] : @"Изготовитель:";
    }
    
    if (_manufactureDateLabel)
    {
        ParameterInformation *manufactureDateParam = nil;
        
        for (ParameterInformation* currentParam in item.additionalParameters)
        {
            if ([currentParam.name isEqualToString:@"ProductionDate"])
                manufactureDateParam = currentParam;
        }
        
        if (manufactureDateParam)
            _manufactureDateLabel.text = [NSString stringWithFormat:@"Дата изгот.: %@", [manufactureDateParam.value stringByReplacingOccurrencesOfString:@" 0:00:00" withString:@""]];
        else
            _manufactureDateLabel.text = @"Дата изгот.:";
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
            NSString *pattern = @".* арт\\..* цв\\.(.*) р-р\\.(.*) р\\.(.*)";
            
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
        _sizeLabel.text = [NSString stringWithFormat:@"%@ %@", size1, size2];
    }
    
    if (_importerLabel)
    {
        ParameterInformation *importerParam = nil;
        
        for (ParameterInformation* currentParam in item.additionalParameters)
        {
            if ([currentParam.name isEqualToString:@"Importer"])
                importerParam = currentParam;
        }
        
        if (importerParam)
            _importerLabel.text = [NSString stringWithFormat:@"Импортер: %@", importerParam.value];
        else
            _importerLabel.text = @"Импортер:";
    }
}

- (void) addOldPriceIfNeeded:(ItemInformation*) item
{
    ParameterInformation *oldPriceParam = nil;
    ParameterInformation *firstPriceParam = nil;
    ParameterInformation *saleParam = nil;
    for (ParameterInformation* currentParam in item.additionalParameters) {
        if ([currentParam.name isEqualToString:@"Старая цена"])
            oldPriceParam = currentParam;
        
        if ([currentParam.name isEqualToString:@"sale"])
            saleParam = currentParam;
        
        if ([currentParam.name isEqualToString:@"FirstPrice"])
            firstPriceParam = currentParam;
    }
    
    /*NSString *message = [NSString stringWithFormat:
                         @"Presence:\n\n"
                         "oldPrice: %@\n"
                         "saleParam: %@\n"
                         "firstPrice: %@\n\n"
                         
                         "Values:\n\n"
                         "saleParam: %@\n"
                         "price: %@"
                         "oldPrice: %@\n"
                         
                         , oldPriceParam?@"YES":@"NO",
                         saleParam?@"YES":@"NO",
                         firstPriceParam?@"YES":@"NO",
                         saleParam.value,
                         @(item.price),
                         oldPriceParam.value];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];*/
    
    if (saleParam && firstPriceParam && oldPriceParam  && [saleParam.value isEqualToString:@"1"] && (item.price <= oldPriceParam.value.doubleValue) )
    {
        
        NSString *addString = [NSString stringWithFormat:@"%@ Ст.цена %@ р.", _dateLabel.text, firstPriceParam.value];
        NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:addString];
        NSInteger location  = _dateLabel.text.length+9;
        NSInteger length    = firstPriceParam.value.length;
        [mutableAttr addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(location,length)];
        _dateLabel.text = @"";
        _dateLabel.attributedText = mutableAttr;
        
    }
}

-(void) drawRect:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState( context );
    CGContextSetShouldSmoothFonts( context , false );
    CGContextSetAllowsFontSmoothing(context, false);
    CGContextSetAllowsAntialiasing( context , false );
    CGContextSetShouldAntialias( context , false );
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [super drawRect:r];
    CGContextRestoreGState( context );
}

- (UIImage*) generateBarcodeFromString:(NSString*) text
{
    CIFilter *imageFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [imageFilter setValue:[text dataUsingEncoding:NSASCIIStringEncoding] forKey:@"inputMessage"];
    
    CGImageRef moi3 = [[CIContext contextWithOptions:nil]
                       createCGImage:[imageFilter outputImage]
                       fromRect:[[imageFilter outputImage] extent]];
    UIImage* finalImage = [UIImage imageWithCGImage:moi3];
    
    NSData *myImageData = UIImagePNGRepresentation(finalImage);
    finalImage = [UIImage imageWithData:myImageData];
    
    return finalImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
