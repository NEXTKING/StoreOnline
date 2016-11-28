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
    _nameLabel.text = item.name;
    _articleLabel.text = item.article;
    _colorLabel.text = item.color;
//    _sizeLabel.text
//    _manufactureDateLabel.text
//    _manufactureLabel.text
    _priceLabel.text = [NSString stringWithFormat:@"Цена: %.0fр.", item.price];
    
    BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:CGRectMake(0, 0, _barcodeView.frame.size.width, _barcodeView.frame.size.height)];
    [_barcodeView addSubview:barCodeView];
    [barCodeView setBarCode:item.barcode];
    [_barcodeView setNeedsDisplay];
    _barcodeLabel.text = item.barcode;
}

- (void) drawRect:(CGRect)r
{
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

@end
