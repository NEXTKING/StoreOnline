//
//  TsumPriceTag.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 14.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "TsumPriceTag.h"

@implementation TsumPriceTag

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

- (void) setItemInformation:(ItemInformation *)item
{
    UIImage* barcode = [self generateBarcodeFromString:item.barcode];
    _barcodeWidthConstraint.constant = barcode.size.width;
    _barocdeImage.image = barcode;
    [_barocdeImage setNeedsDisplay];
    _barcodeTextField.text = item.barcode;
    
    _nameLabel.text     = item.name;
    _articleLabel.text  = [NSString stringWithFormat:@"Арт: %@", item.article];
    _priceLabel.text    = [NSString stringWithFormat:@"Цена: %.0f руб. %02d коп", item.price, (int)((item.price - trunc(item.price))*100)];
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    for (ParameterInformation* paramInfo in item.additionalParameters) {
        [params setObject:paramInfo.value forKey:paramInfo.name];
    }
    
     NSString* size      = [params objectForKey:@"Размер"] ? [params objectForKey:@"Размер"]:@"-";
    NSString* brand     = [params objectForKey:@"Brand"] ? [params objectForKey:@"Brand"]:@"-";
    NSString* country   = [params objectForKey:@"Страна"] ? [params objectForKey:@"Страна"]:@"-";
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString* date = [dateFormatter stringFromDate:[NSDate date]];
    
    _brandLabel.text = brand;
    _dateLabel.text  = date;
    _countryLabel.text = country;
    _sizeLabel.text = size;
    
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


@end
