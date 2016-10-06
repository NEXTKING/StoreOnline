//
//  DesondoProductController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 16.02.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "DesondoProductController.h"
#import "StockDescriptionController.h"
#import "ImageViewerController.h"
#import "WarehouseInformation.h"

@interface DesondoProductController ()

@end

@implementation DesondoProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _inStockLabel.layer.borderColor     = [UIColor blackColor].CGColor;
    _reseverdLabel.layer.borderColor    = [UIColor blackColor].CGColor;
    _inStockLabel.layer.borderWidth     = 1.0;
    _reseverdLabel.layer.borderWidth    = 1.0;
    
    [self.view bringSubviewToFront:self.statusView];
    
    [self barcodeData:@"2180146" type:0];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateItemInfo:(ItemInformation *)itemInfo
{
    [super updateItemInfo:itemInfo];
    self.itemArticleLabel.text  = [NSString stringWithFormat:@"Артикул: %@", itemInfo.article];
    self.itamMaterialLabel.text = itemInfo.material ? itemInfo.material:@"-";
    self.itemColorLabel.text    = itemInfo.color ? itemInfo.color:@"-";
    self.itemLengthLabel.text   = itemInfo.length ? [NSString stringWithFormat:@"%.1f",itemInfo.length.doubleValue]:@"-";
    self.itemWidthLabel.text    = itemInfo.width ? [NSString stringWithFormat:@"%.1f",itemInfo.width.doubleValue]:@"-";
    self.itemHeightLabel.text   = itemInfo.height ? [NSString stringWithFormat:@"%.1f",itemInfo.height.doubleValue]:@"-";
    self.itemDiameterLabel.text = itemInfo.diameter ? [NSString stringWithFormat:@"%.1f",itemInfo.diameter.doubleValue]:@"-";
    
    if (itemInfo.warehouses)
    {
        NSInteger inStockCount  = 0;
        NSInteger reservedCount = 0;
        for (WarehouseInformation *warehouse in itemInfo.warehouses) {
            inStockCount    += warehouse.count;
            reservedCount   += warehouse.reservedCount;
        }
        
        self.inStockLabel.text  = [NSString stringWithFormat:@"%d", inStockCount];
        self.reseverdLabel.text = [NSString stringWithFormat:@"%d", reservedCount];
    }
}

- (void) clearInfo
{
    [super clearInfo];
    self.itemPriceLabel.text = @"";
    _reseverdLabel.text = @"-";
    _inStockLabel.text = @"-";
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    _temporaryView.hidden = YES;
    [super barcodeData:(NSString *)barcode type:(int)type];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    _temporaryView.hidden = YES;
    [super barcodeData:(NSString *)barcode isotype:isotype];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    StockDescriptionController* stockVC = segue.destinationViewController;
    stockVC.item = self.currentItemInfo;
}

#pragma mark - Image handler

- (void) startLoadingImage:(NSString *)imageName
{
    if (imageName.length > 0)
    {
        _itemImage.image = nil;
        [_imageLoadingIndicator startAnimating];
        _imageGestureRecognizer.enabled = NO;
    }
    
    [super startLoadingImage:imageName];
}

- (void) imageLoaded:(UIImage *)image
{
    [super imageLoaded:image];
    
    [_imageLoadingIndicator stopAnimating];
    
    if (image)
    {
        _itemImage.image = image;
        _imageGestureRecognizer.enabled = YES;
    }
    else
        _itemImage.image = [UIImage imageNamed:@"image_placeholder.png"];
}

- (IBAction)imageTappedAction:(id)sender
{
    ImageViewerController *viewer = [[ImageViewerController alloc] init];
    viewer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    viewer.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [[self topMostController] presentViewController:viewer animated:YES completion:nil];
    viewer.imageView.image = _itemImage.image;
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
