//
//  PrintViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21.01.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "PrintViewController.h"
#import "DTDevices.h"
#import "OstinPriceTag.h"
#import "AzbukaPriceTag.h"
#import "TsumPriceTag.h"
#import "MelonPriceTag.h"
#import <QuartzCore/QuartzCore.h>

typedef enum PrintingTask
{
    PrintingTaskNone = 0,
    PrintingTaskPrintLabel = 1,
    PrintingTaskFeed = 2,
    PrintingTaskCalibrate =3,
    PrintingTaskRetract = 4,
    PrintingTaskZPL = 5
} PrintingTask;

@interface PrintViewController () <DTDeviceDelegate, UIAlertViewDelegate>
{
    DTDevices *dtDevice;
    BOOL shouldContinueDiscover;
    NSInteger numberOfCopies;
    PrintingTask currentTask;
    NSData* currentZpl;
}

@property (nonatomic, strong) ItemInformation* currentPrint;


@end

@implementation PrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    shouldContinueDiscover = NO;
    _currentPrint = nil;
    dtDevice = [DTDevices sharedDevice];
    [dtDevice addDelegate:self];
    [_activityIndicator startAnimating];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowOffset = CGSizeMake(-5, 10);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 0.5;
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.cornerRadius = 8.0;
    
    //[self fillBarcodeView];
    
    
    //_receiptView.layer.borderWidth = 2.0;
    //_receiptView.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tryConnectAndPrint
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterID"] && _delegate)
    {
        NSError *error = [NSError errorWithDomain:@"0" code:0 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"Необходимо привязать принтер", nil)}];
        [_delegate printerDidFailPrinting:error];
        return;
    }
    
    
    if (dtDevice.btConnectedDevices.count > 0)
    {
        [self doPrinting];
        return;
    }
   // else if (![NSUserDefaults currentPrinterID])
   //     [self bindPrinterWithId:[NSUserDefaults currentPrinterID]];
   // else
   // {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (dtDevice.btConnectedDevices.count < 1 && shouldContinueDiscover) {
                [dtDevice btConnectSupportedDevice:[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterID"] pin:@"0000" error:nil];
                //[dtDevice btConnectSupportedDevice:@"000190C4DD06" pin:@"0000" error:nil];
            }
            
            if (!shouldContinueDiscover)
                return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self doPrinting];
            });
        });
   // }
}

- (void) startSearchingPtinter
{
    shouldContinueDiscover = YES;
    
    NSError *error = nil;
    
    if (dtDevice.btConnectedDevices.count < 1)
    {
        [dtDevice btDiscoverPrintersInBackground:&error];
        _statusLabel.text = @"Searching printer...";
    }
    
    if (error)
        [self showInfoMessage:error.localizedDescription];
}

- (void) stopSearchingPrinter
{
    shouldContinueDiscover = NO;
    _statusLabel.text = @"";
}

- (void) calibrate
{
    currentTask = PrintingTaskCalibrate;
    _statusLabel.text = NSLocalizedString(@"Подключение к принтеру...", nil);
    shouldContinueDiscover = YES;
    [self tryConnectAndPrint];
    
}

- (void) temporaryFeed
{
    currentTask = PrintingTaskRetract;
    _statusLabel.text = NSLocalizedString(@"Подключение к принтеру...", nil);
    shouldContinueDiscover = YES;
    [self tryConnectAndPrint];
}

- (void) print:(ItemInformation *)itemInfo copies:(NSInteger) copies
{
    currentTask = PrintingTaskPrintLabel;
    numberOfCopies = MAX(copies, 1);
    _statusLabel.text = NSLocalizedString(@"Подключение к принтеру...", nil);
    self.currentPrint = itemInfo;
    shouldContinueDiscover = YES;
    [self tryConnectAndPrint];
    //if (dtDevice.btConnectedDevices.count < 1)
    //    [self startSearchingPtinter];
    //else
    //    [self doPrinting];
    
    /*MelonPriceTag* priceTag = [[[NSBundle mainBundle] loadNibNamed:@"MelonPriceTag" owner:nil options:nil] objectAtIndex:0];
    [priceTag setItemInformation:_currentPrint];
    [priceTag setNeedsLayout];
    [priceTag layoutIfNeeded];
    [priceTag setNeedsDisplay];
    UIImage *imageToPrint = [self imageWithView:priceTag];
    UIImageWriteToSavedPhotosAlbum(imageToPrint,
                                   nil,
                                   NULL,
                                   nil);*/
    
}

- (void) printZPL:(NSData*) data copies:(NSInteger) copies{
    currentTask = PrintingTaskZPL;
    numberOfCopies = MAX(copies, 1);
    _statusLabel.text = NSLocalizedString(@"Подключение к принтеру...", nil);
    currentZpl = data;
    shouldContinueDiscover = YES;
    
    [self tryConnectAndPrint];
}

#pragma mark - DTDevices Delegate

- (void) bluetoothDiscoverComplete:(BOOL)success{
    
    if ((!success || dtDevice.btConnectedDevices.count < 1) && shouldContinueDiscover)
        [dtDevice btDiscoverPrintersInBackground:nil];
}

- (void) bluetoothDeviceDiscovered:(NSString *)address name:(NSString *)name
{
    NSError *error;
    [self showInfoMessage:[NSString stringWithFormat:@"Discovered %@", address]];
    
    [dtDevice btConnectSupportedDevice:address pin:@"0000" error:&error];
    if (error)
    {
        [self showInfoMessage:error.localizedDescription];
        if (shouldContinueDiscover)
            [dtDevice btDiscoverPrintersInBackground:nil];
    }
}

- (void) bluetoothDeviceDisconnected:(NSString *)address
{
    
}

- (void) bluetoothDeviceConnected:(NSString *)address
{
   // [self showInfoMessage:[NSString stringWithFormat:@"Connected %@", address]];
    
    [self performSelector:@selector(doPrinting) withObject:nil afterDelay:1.0];
}

- (void) doPrinting
{
    switch (currentTask) {
        case PrintingTaskPrintLabel:
        case PrintingTaskFeed:
            [self printLabel];
            break;
        case PrintingTaskCalibrate:
            [self calibratePrinter];
            break;
        case PrintingTaskRetract:
            [self temporaryFeedForValue:70.0];
            break;
        case PrintingTaskZPL:
            [self printZPL];
            break;
        default:
            break;
    }
}

- (void) printLabel
{
    _statusLabel.text = @"Печать...";
    
    if (!_currentPrint)
    {
        [dtDevice prnFeedPaper:0 error:nil];
        [self performSelector:@selector(performCallback) withObject:nil afterDelay:2.0];
        return;
    }
    
    UIImage *imageToPrint = nil;
    
#if defined (OSTIN)
    OstinPriceTag *priceTag = [[[NSBundle mainBundle] loadNibNamed:@"OstinPriceTag" owner:nil options:nil] objectAtIndex:0];
    [priceTag setItemInformation:_currentPrint];
    [priceTag setNeedsLayout];
    [priceTag layoutIfNeeded];
    [priceTag setNeedsDisplay];
    imageToPrint = [self imageWithView:priceTag];
#elif defined (TSUM)
    TsumPriceTag* priceTag = [[[NSBundle mainBundle] loadNibNamed:@"TsumPriceTag" owner:nil options:nil] objectAtIndex:0];
    [priceTag setItemInformation:_currentPrint];
    [priceTag setNeedsLayout];
    [priceTag layoutIfNeeded];
    [priceTag setNeedsDisplay];
    imageToPrint = [self imageWithView:priceTag];
#elif defined (MELON)
    NSString *xibName = [[NSUserDefaults standardUserDefaults] valueForKey:@"PriceTagXibName"];
    MelonPriceTag* priceTag = [[[NSBundle mainBundle] loadNibNamed:(xibName?xibName:@"MelonPriceTag") owner:nil options:nil] objectAtIndex:0];
    [priceTag setItemInformation:_currentPrint];
    [priceTag setNeedsLayout];
    [priceTag layoutIfNeeded];
    [priceTag setNeedsDisplay];
    imageToPrint = [self imageWithView:priceTag];
#else
    AzbukaPriceTag *priceTag = [[[NSBundle mainBundle] loadNibNamed:@"AzbukaPriceTag" owner:nil options:nil] objectAtIndex:0];
    [priceTag setItem:_currentPrint];
    [priceTag setNeedsLayout];
    [priceTag layoutIfNeeded];
    [priceTag setNeedsDisplay];
    imageToPrint = [self imageWithView:priceTag];
#endif
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSError *error = nil;
        //[dtDevice prnPrintText:_currentPrint error:&error];
        
        //[self retractPaper];
        //[dtDevice prnFeedPaper:30 error:nil];
        
        for ( int i = 0; i < numberOfCopies; ++i) {
            
            [dtDevice prnSetDensity:160 error:nil];
            [dtDevice pageStart:nil];
            [dtDevice pageSetWorkingArea:0 top:0 width:0 height:imageToPrint.size.height error:nil];
            [dtDevice prnPrintImage:imageToPrint align:ALIGN_CENTER error:nil];
            [dtDevice pagePrint:nil];
            [dtDevice pageEnd:nil];
            
            //[dtDevice prnSetBarcodeSettings:2 height:40 hriPosition:BAR_TEXT_BELOW align:ALIGN_LEFT error:&error];
            //[dtDevice prnPrintBarcode:BAR_PRN_CODE128 barcode:[_currentPrint.barcode dataUsingEncoding:NSASCIIStringEncoding] error:&error];
            [dtDevice prnFeedPaper:0 error:nil];
        }
        
        
if (_shouldRetrack)
{
    [self temporaryFeedForValue:70.0];
}
        
        self.currentPrint = nil;
        
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showInfoMessage:error.localizedDescription];
            });
            //[dtDevice btDisconnect:nil error:nil];
            //[self startSearchingPtinter];
        }
        
    });
    
    [self performSelector:@selector(performCallback) withObject:nil afterDelay:2.0];
    //[self performSelector:@selector(retractPaper) withObject:nil afterDelay:5.0];
    
    currentTask = PrintingTaskNone;

}


- (void) printZPL
{
    _statusLabel.text = @"Печать...";
    
    if (!currentZpl)
    {
        [self performSelector:@selector(performCallback) withObject:nil afterDelay:2.0];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError* error = nil;
        [dtDevice btWrite:currentZpl.bytes length:currentZpl.length error:&error];
        
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showInfoMessage:error.localizedDescription];
            });
            //[dtDevice btDisconnect:nil error:nil];
            //[self startSearchingPtinter];
        }
        
    });
    
    [self performSelector:@selector(performCallback) withObject:nil afterDelay:2.0];
    //[self performSelector:@selector(retractPaper) withObject:nil afterDelay:5.0];
    
    currentTask = PrintingTaskNone;
}

- (void) calibratePrinter
{
    _statusLabel.text = @"Калибровка...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block NSError *error = nil;
        
        int calib = 0;
        [dtDevice prnCalibrateBlackMark:&calib error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
                [self showInfoMessage:error.localizedDescription];
            [self performSelector:@selector(performCallback) withObject:nil afterDelay:0.0];
        });
        
    });
    
    //[self performSelector:@selector(retractPaper) withObject:nil afterDelay:5.0];
    currentTask = PrintingTaskNone;
    
}

- (void) temporaryFeedForValue:(CGFloat) value
{
    _statusLabel.text = @"Подача ценника...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    [dtDevice prnFeedPaperTemporary:value error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self performSelector:@selector(performCallback) withObject:nil afterDelay:0.0];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Внимание", nil) message:NSLocalizedString(@"Оторвите ценник и нажмите \"Продолжить\"", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Продолжить", nil) otherButtonTitles: nil];
        [alert show];
    });
    });
}

- (void) retractPaper
{
    NSError *error = nil;
    [dtDevice prnRetractPaper:&error];
    if (error)
        [self showInfoMessage:error.localizedDescription];
}

- (void) performCallback
{
    if (_delegate)
        [_delegate printerDidFinishPrinting];
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Info", nil) message:info delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
    [alert show];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIView* landscapeView = nil;

#ifdef LANDSCAPE
    {
        UIView *rotatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.height, view.frame.size.width)];
        [rotatedView addSubview:view];
        view.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        CGRect newRect = view.frame;
        newRect.origin = CGPointMake(0, 0);
        view.frame = newRect;
        
        landscapeView = rotatedView;
    }
#endif
    
   /* UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    textView.backgroundColor = [UIColor whiteColor];
    
    AntiAliasTextLayer *textLayer = [AntiAliasTextLayer layer];
    
    textLayer.frame = textView.frame;
    textLayer.string = @"QWE qwe qwe 123 dqwpomd pomdw opmqwd op dqwmp dP OMSADPOM POMDPOASM DPOMASP ODMpom dqpomqwop mpwqmd omdpwo mPM DSAPOMAS POMD POMA DSPOMpo dmqwdpom pqowdm "
    ;
    textLayer.font = (__bridge CFTypeRef _Nullable)([UIFont fontWithName:@"Arial" size:13].fontName);
    textLayer.fontSize = 7;
    textLayer.wrapped = YES;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.backgroundColor = [UIColor whiteColor].CGColor;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    //[textView.layer addSublayer:textLayer]; */
    
    //view = textView;
    
    UIView *viewToPrint = landscapeView ? landscapeView:view;
    
    UIGraphicsBeginImageContextWithOptions(viewToPrint.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    [viewToPrint.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *myImageData = UIImagePNGRepresentation(image);
    UIImage *umageToPrint = [UIImage imageWithData:myImageData];


    
    /*UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldSmoothFonts( context , false );
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize size = image.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[image CGImage] scale:0.0 orientation:UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();*/
    
    return umageToPrint;
}


//static inline double radians (double degrees) {return degrees * M_PI/180;}

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
    
    /*CGSize newSize = CGSizeMake(300, 46);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [finalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //[self showInfoMessage:NSStringFromCGSize(newImage.size)];
    return newImage;*/
    
    return finalImage;
}

- (void) fillBarcodeView
{
    
    NSString *string = @"11010000100100010001101101110100010001101000110010111001110110111010011101100110010011101100011101011";
    
    CGFloat xOffset = 0.0f;
    CGFloat barWidth = 1.5;
    
    for (NSInteger charIdx=0; charIdx<string.length; charIdx++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,xOffset , _barcodeView.frame.size.height, barWidth)];
        
        // Do something with character at index charIdx, for example:
        unichar currentChar = [string characterAtIndex:charIdx];
        if (currentChar == '1')
            view.backgroundColor = [UIColor blackColor];
        else
            view.backgroundColor = [UIColor whiteColor];
        
        [_barcodeView addSubview:view];
        
        xOffset+=barWidth;
    }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self retractPaper];
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
