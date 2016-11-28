//
//  OstinPriceTag.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 29.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "OstinPriceTag.h"

@implementation OstinPriceTag

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

- (void) awakeFromNib
{
    [super awakeFromNib];
    
}

- (void) setItemInformation:(ItemInformation *)item
{
    NSMutableString *descriptionString = [NSMutableString new];
    ParameterInformation* contents      = nil;
    ParameterInformation* importer      = nil;
    ParameterInformation* size          = nil;
    ParameterInformation* manufacturer  = nil;
    ParameterInformation* madeIn        = nil;
    ParameterInformation* madeOn        = nil;
    ParameterInformation* gost          = nil;
    ParameterInformation* localSize     = nil;
    ParameterInformation* drop          = nil;
    ParameterInformation* storeNumber   = nil;
    ParameterInformation* merchantCode  = nil;
    ParameterInformation* boxType       = nil;
    
    
    
    for (ParameterInformation* currentParam in item.additionalParameters) {
        if ([currentParam.name isEqualToString:@"Состав"])
            contents = currentParam;
        //if ([currentParam.name isEqualToString:@"Импортер"])
        //    importer = currentParam;
        if ([currentParam.name isEqualToString:@"Размер"])
            size = currentParam;
        if ([currentParam.name isEqualToString:@"Производитель"])
            manufacturer = currentParam;
        if ([currentParam.name isEqualToString:@"Страна изготовитель"])
            madeIn = currentParam;
        if ([currentParam.name isEqualToString:@"Дата изготовления"])
            madeOn = currentParam;
        if ([currentParam.name isEqualToString:@"Импортер в РФ"])
            importer = currentParam;
        if ([currentParam.name isEqualToString:@"ГОСТ"])
            gost = currentParam;
        if ([currentParam.name isEqualToString:@"Размер отечественный"])
            localSize = currentParam;
        if ([currentParam.name isEqualToString:@"Drop.Drop"])
            drop = currentParam;
        if ([currentParam.name isEqualToString:@"Номер магазина"])
            storeNumber = currentParam;
        if ([currentParam.name isEqualToString:@"Код продавца"])
            merchantCode = currentParam;
        if ([currentParam.name isEqualToString:@"Тип короба"])
            boxType = currentParam;
    }
    
    if (contents)
    {
        NSString* formattedContents = [contents.value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [descriptionString appendFormat:@"Состав: %@", formattedContents];
    }
    if (madeIn)
        [descriptionString appendFormat:@" Сделано в %@", madeIn.value];
    if (madeOn)
        [descriptionString appendFormat:@" Изготовлено: %@", madeOn.value];
    if (gost)
        [descriptionString appendFormat:@" %@", gost.value?gost.value:@""];
    if (importer)
        [descriptionString appendFormat:@" Импортер: %@", importer.value];
    if (manufacturer)
        [descriptionString appendFormat:@" Изготовитель: %@", manufacturer.value];
    if (boxType)
        [descriptionString appendFormat:@"\n%@", boxType.value];
    
    
    
    _nameLabel.text             = item.name;
    _priceLabel.text            = [NSString stringWithFormat:@"%.0f,-", item.price];
    _articleLabel.text          = item.article;
    //_descriptionLabel.text      = descriptionString;
    _bigSizeLabel.text          = size ? size.value:@"Б/р";
    _smallSizeLabel.text        = localSize.value;
    _dropLabel.text             = drop.value;
    _shopCodeLabel.text         = [NSString stringWithFormat:@"%@ %@", storeNumber.value, merchantCode.value];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    _dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSString* barcode = item.barcode;
    
    UIImage *barcodeImage = [self generateBarcodeFromString:barcode];
    _barcodeWidthConstraint.constant = barcodeImage.size.width;
    _barocdeImage.image = barcodeImage;
    [_barocdeImage setNeedsDisplay];
    
}

- (UIImage*) generateBarcodeFromString:(NSString*) text
{
    CIFilter *imageFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [imageFilter setValue:[text dataUsingEncoding:NSASCIIStringEncoding] forKey:@"inputMessage"];
    
    CGImageRef moi3 = [[CIContext contextWithOptions:nil]
                       createCGImage:[imageFilter outputImage]
                       fromRect:[[imageFilter outputImage] extent]];
    UIImage* finalImage = [UIImage imageWithCGImage:moi3];
    
    //NSData *myImageData = UIImagePNGRepresentation(finalImage);
    //finalImage = [UIImage imageWithData:myImageData];
    
    return finalImage;
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ostin" message:info delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


@end
