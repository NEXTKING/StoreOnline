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
    
    id firstPriceParam = nil;
    if (item.additionalParameters && item.additionalParameters[@"FirstPrice"])
    {
        if ([item.additionalParameters[@"FirstPrice"] isKindOfClass:[NSString class]])
            firstPriceParam = item.additionalParameters[@"FirstPrice"];
    }
    
    if (firstPriceParam)
        self.priceLabel.text = [NSString stringWithFormat:@"Цена: %@р.", firstPriceParam];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldPrintBarcode"])
    {
        [self.barcodeView setHidden:NO];
        BarCodeView *barCodeView = [[BarCodeView alloc] initWithFrame:CGRectMake(0, 0, self.barcodeView.frame.size.width, self.barcodeView.frame.size.height)];
        [self.barcodeView addSubview:barCodeView];
        [barCodeView setBarCode:item.barcode];
        [self.barcodeView setNeedsDisplay];
    }
    
    self.materialLabel.text = [NSString stringWithFormat:@"Состав: %@", item.material];
}

@end
