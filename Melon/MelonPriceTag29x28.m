//
//  MelonPriceTag29x28.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 30/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonPriceTag29x28.h"
#import "BarCodeView.h"

@implementation MelonPriceTag29x28

- (void)setItemInformation:(ItemInformation *)item
{
    [super setItemInformation:item];
    
    ParameterInformation *firstPriceParam = nil;
    for (ParameterInformation* currentParam in item.additionalParameters)
    {
        if ([currentParam.name isEqualToString:@"FirstPrice"])
            firstPriceParam = currentParam;
    }
    
    if (firstPriceParam)
        self.priceLabel.text = [NSString stringWithFormat:@"Цена: %@р.", firstPriceParam.value];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldPrintBarcode"])
    {
        [self.barcodeView setHidden:NO];
        BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:CGRectMake(0, 0, self.barcodeView.frame.size.width, self.barcodeView.frame.size.height)];
        [self.barcodeView addSubview:barCodeView];
        [barCodeView setBarCode:item.barcode];
        [self.barcodeView setNeedsDisplay];
    }
}

@end
