//
//  AzbukaPriceTag.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 04.03.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AzbukaPriceTag.h"

@implementation AzbukaPriceTag

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

- (void) setItem: (ItemInformation*) item
{
    _nameLabel.text = item.name;
    UIImage *barcodeImage = [self generateBarcodeFromString:item.barcode];
    _barcodeWidthConstraint.constant = barcodeImage.size.width;
    _barcodeView.image = barcodeImage;
    [_barcodeView setNeedsDisplay];
    _priceLabel.text = [NSString stringWithFormat:@"%.0f.--", item.price];
    
    BOOL shouldPrintDiscount = NO;
    for (ParameterInformation* paramInfo in item.additionalParameters) {
        if ([paramInfo.name isEqualToString:@" marked"] && [paramInfo.value isEqualToString:@"1"])
        {
            shouldPrintDiscount = YES;
            break;
        }
    }
    
    _discountImage.hidden = !shouldPrintDiscount;
    
}

@end
