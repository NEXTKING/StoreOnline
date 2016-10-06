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
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"0 р."];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
    _oldPriceLabel.attributedText = attributeString;
    
    _priceLabel.text = [NSString stringWithFormat:@"Цена: %.0fр.", item.price];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    _dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    [self addOldPriceIfNeeded:item];
    
    BOOL shouldPrintBarcode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ShouldPrintBarcode"] boolValue];
    
    if (!shouldPrintBarcode)
    {
        _barcodeLabel.hidden = YES;
        _barcodeView.hidden = YES;
        return;
    }
    _barcodeLabel.text = item.barcode;
    //UIImage *barcodeImage = [self generateBarcodeFromString:item.barcode];
    //_barcodeView.image = barcodeImage;
    BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:CGRectMake(0, 0, _barcodeView.frame.size.width, _barcodeView.frame.size.height)];
    [_barcodeView addSubview:barCodeView];
    [barCodeView setBarCode:item.barcode];

    [_barcodeView setNeedsDisplay];
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
   /* NSString *message = [NSString stringWithFormat:@"%@ %@", oldPriceParam?@"YES":@"NO", saleParam?@"YES":@"NO"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show]; */
    
    if (saleParam && firstPriceParam && oldPriceParam  && [saleParam.value isEqualToString:@"1"] && (item.price != oldPriceParam.value.doubleValue) )
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
