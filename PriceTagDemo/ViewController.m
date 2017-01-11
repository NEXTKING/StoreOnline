//
//  ViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21.01.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ViewController.h"
#import "DetailsTableViewController.h"
#import "OstinPriceTag.h"

@interface ViewController ()
{
    PrintViewController *printVC;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice addDelegate:self];
    
    NSError *error = nil;
    [dtDevice connect];
    [self connectionState:dtDevice.connstate];
    
    NSLog(@"Error descripion: %@", error.localizedDescription);
    // Do any additional setup after loading the view, typically from a nib.
    
    printVC = [PrintViewController new];
    printVC.delegate = self;
    [self.view addSubview:printVC.view];
    printVC.view.hidden = YES;
    
    //[[MCPServer instance] itemDescription:self itemCode:@"12345"];
    _printButton.enabled        = NO;
    _printButtonItem.enabled    = NO;
    _detailsButton.enabled      = NO;
    _numberOfCopies = 1;
    
    [self clearInfo];
}


- (void) clearInfo
{
    _itemNameLabel.text = @"";
    _barcodeLabel.text = @"";
    _itemArticleLabel.text = @"";
    _itemPriceLabel.text = @"0.00";
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev addDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scanNotification:)
                                                 name:@"BarcodeScanNotification"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev removeDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect printFrame = printVC.view.frame;
    printFrame.size.height = 100;
    printFrame.size.width = 200;
    printVC.view.frame = printFrame;
    printVC.view.center = self.view.center;
    
    if (![[UINavigationBar appearance] isTranslucent])
        printVC.view.frame = CGRectMake(printVC.view.frame.origin.x, printVC.view.frame.origin.y - 64, 200, 100);
    
    _statusView.layer.cornerRadius = _statusView.frame.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showInfoMessage:(NSString*) info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:info delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)manualInputAction:(id)sender
{
   
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Ручной ввод", nil)
                                                                   message:NSLocalizedString(@"Введите штрих-код", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Отправить", nil) style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                              NSDictionary* params = @{@"barcode":alert.textFields[0].text,@"type":@(0)};
                                                              
                                                              [[NSNotificationCenter defaultCenter]
                                                               postNotificationName:@"BarcodeScanNotification"
                                                               object:params];
                                                          }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField* textField)
     {
         textField.keyboardType = UIKeyboardTypeNumberPad;
     }];
    
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Device delegate methods

- (void) connectionState:(int)state
{
    switch (state) {
        case CONN_CONNECTED:
        {
            _statusView.backgroundColor = [UIColor greenColor];
            
            DTDevices *dtDevice = [DTDevices sharedDevice];
            _stateLabel.text = [NSString stringWithFormat:@"Case connected: %@", dtDevice.deviceName];
            [dtDevice emsrConfigMaskedDataShowExpiration:TRUE showServiceCode:TRUE showTrack3:FALSE unmaskedDigitsAtStart:6 unmaskedDigitsAtEnd:2 unmaskedDigitsAfter:7 error:nil];
            [dtDevice emsrSetEncryption:7 keyID:2 params:nil error:nil];
            
            //[dtDevice emsrConfigMaskedDataShowExpiration:TRUE showServiceCode:TRUE showTrack3:FALSE unmaskedDigitsAtStart:6 unmaskedDigitsAtEnd:2 unmaskedDigitsAfter:7 error:nil];
            //[dtDevice emsrSetEncryption:7 keyID:2 params:nil error:nil];
               //[printVC startSearchingPtinter];
            
        }
            break;
        case CONN_CONNECTING:
            _stateLabel.text = @"No case connected";
            _statusView.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
        case CONN_DISCONNECTED:
            _stateLabel.text = @"No case connected";
            _statusView.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
            
        default:
            break;
    }
    
    _printButton.enabled = (state == CONN_CONNECTED) && _currentItemInfo;
    _printButtonItem.enabled = (state == CONN_CONNECTED) && _currentItemInfo;
    //_searchPrinterButton.enabled = (state == CONN_CONNECTED);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailsTableViewController* detailsVC = segue.destinationViewController;
    detailsVC.item = self.currentItemInfo;
}

#pragma mark - Printer delegate

- (IBAction)cartAddButtonAction:(id)sender
{
    NSDictionary *userInfo = @{@"item":_currentItemInfo};
    NSNotification *notification = [[NSNotification alloc] initWithName:@"CartAddMessage" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)printButtonAction:(id)sender
{
    printVC.shouldRetrack = self.shouldRetrack;
    printVC.view.hidden = NO;
#ifndef ZPL
    [printVC print:_currentItemInfo copies:_numberOfCopies];
#else
    [printVC printZPL:_currentZPLInfo copies:1];
#endif
}

- (IBAction)retractAction:(id)sender
{
    printVC.view.hidden = NO;
    [printVC temporaryFeed];
}

- (IBAction)leftButtonAction:(id)sender
{
   /* NSError *error;
    //const char myByteArray[] = {0x07}; //BEEP
    const char myByteArray[] = {0x1D,0x29,0x2E,0x2E,0x2E,0x2E,0x2E,0x31,0x30,0x2E,0x2E,0x2E}; //Activate Gap Sensor
    
    DTDevices *dtDevice = [DTDevices sharedDevice];
    NSData *dataToSend = [NSData dataWithBytes:myByteArray length:sizeof(myByteArray)];
    [dtDevice prnWriteDataToChannel:1 data:dataToSend error:&error];
    //[dtDevice prnFeedPaper:0 error:nil];
    
    if (error)
        [self showInfoMessage:error.localizedDescription];*/
    
    printVC.view.hidden = NO;
    [printVC print:nil copies:1];
}

- (IBAction)calibrateAction:(id)sender
{
    printVC.view.hidden = NO;
    [printVC calibrate];
}

- (void) printerDidFinishPrinting
{
    printVC.view.hidden = YES;
}

- (void) printerDidFailPrinting:(NSError *)error
{
    [self showInfoMessage:error.localizedDescription];
    printVC.view.hidden = YES;
}

#pragma mark - Scanner Delegate

- (void) scanNotification:(NSNotification*)aNotification
{
    lastBarcode = [aNotification.object objectForKey:@"barcode"];
    int type    = [[aNotification.object objectForKey:@"type"] intValue];
    
    [[NSUserDefaults standardUserDefaults] setValue:lastBarcode forKey:@"LastBarcode"];
    [self requestItemInfoWithCode:[self cleanBarcode:lastBarcode] isoType:type];
}

- (NSString*) cleanBarcode:(NSString*) barcode
{
    NSRange eqRange = [barcode rangeOfString:@"="];
    if (eqRange.location != NSNotFound && barcode.length>eqRange.location+1)
        return [barcode substringFromIndex:eqRange.location+1];
    
    NSRange dotRange = [barcode rangeOfString:@"."];
    if (dotRange.location != NSNotFound && barcode.length>dotRange.location+3)
        return [barcode substringFromIndex:dotRange.location+3];
    
    return barcode;
}


- (void) magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    NSRange trackRange = {.location = 1, .length = track2.length-2};
    NSString* cardCode = [track2 substringWithRange:trackRange];
    [self requestItemInfoWithCode:cardCode isoType:0];
}

- (void) requestItemInfoWithCode:(NSString*) code isoType:(int) type
{
    
    [_loadingActivity startAnimating];
    [_printButton   setEnabled:NO];
    [_printButtonItem setEnabled:NO];
    [_detailsButton setEnabled:NO];
    
#if defined (RIVGOSH)
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        
        NSData *returnData = [[NSData alloc]init];
        
        //Build the Request
        NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.113:7731/auth/4584GGR/?code=%@", code];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        NSString *params = @"";
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[params length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        //Send the Request
        returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
        //Get the Result of Request
       // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            
            if (result)
            {
                ItemInformation *itemInfo = [ItemInformation new];
                NSDictionary *privelegiesDict = [result objectForKey:@"Полномочия"];
                NSEnumerator *keyEnumerator = [privelegiesDict keyEnumerator];
                NSString *currentKey = nil;
                NSMutableArray *mutableArray = [NSMutableArray new];
                while (currentKey = [keyEnumerator nextObject]) {
                    ParameterInformation* paramInfo = [ParameterInformation new];
                    paramInfo.name = currentKey;
                    NSNumber *value = [privelegiesDict objectForKey:currentKey];
                    paramInfo.value =  [NSString stringWithFormat:@"%@", value];
                    [mutableArray addObject:paramInfo];
                }
                
                itemInfo.additionalParameters = mutableArray;
                
                [self itemDescriptionComplete:0 itemDescription:itemInfo];
            }
            else
                [self itemDescriptionComplete:1 itemDescription:nil];
        });
    });
#elif defined (INVENTORY)
    [[MCPServer instance] inventoryItemDescription:self itemCode:code];
#else
    [[MCPServer instance] itemDescription:self itemCode:code shopCode:nil isoType:type];
#endif
}

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    [_loadingActivity stopAnimating];
    self.currentItemInfo = nil;
    
    if (result == 0)
    {
        [_printButton   setEnabled:YES];
        [_printButtonItem setEnabled:YES];
        [_detailsButton setEnabled:YES];
        self.currentItemInfo = itemDescription;
        [self updateItemInfo:itemDescription];
        [self startLoadingImage:itemDescription.imageName];
        [self compareAmount:itemDescription];
    }
    else if (result == 1)
    {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"LastBarcode"];
        [self showInfoMessage:NSLocalizedString(@"Не удалось найти товар в базе", nil)];
        [self clearInfo];
        
        DTDevices* dtDev = [DTDevices sharedDevice];
        int data[] = {1000,200,700,200,500,200,700,200};
        [dtDev playSound:100 beepData:data length:sizeof(data) error:nil];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"LastBarcode"];
        [self showInfoMessage:NSLocalizedString(@"Ошибка при выполнении запроса.", nil)];
        [self clearInfo];
    }
}

- (void) compareAmount:(ItemInformation*) itemInfo
{
    NSString* amountString = nil;
    NSRange eqRange = [lastBarcode rangeOfString:@"="];
    NSRange dotRange = [lastBarcode rangeOfString:@"."];
    
    if (eqRange.location != NSNotFound)
        amountString = [lastBarcode substringWithRange:NSMakeRange(0, eqRange.location)];
    else if (dotRange.location != NSNotFound)
        amountString = [lastBarcode substringWithRange:NSMakeRange(0, dotRange.location)];
    else
    {
        [self amountCompareCompleted:NO];
        return;
    }
    
    if (amountString)
    {
        double printedAmount = [amountString doubleValue];
        [self amountCompareCompleted:(printedAmount == itemInfo.price)];
        return;
    }
    
    [self amountCompareCompleted:NO];
}

- (void) amountCompareCompleted:(BOOL)isEqual
{
    
}

- (void) startLoadingImage:(NSString*) imageName
{
    if (imageName.length > 0)
    {
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            /* Fetch the image from the server... */
            
            NSString *urlPath = @"http://185.36.157.150:7755/storeService/Service1.svc/json/Photo?id=";
            NSString *fullAddress = [NSString stringWithFormat:@"%@%@", urlPath, imageName];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullAddress]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            
            
            //NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSData *data = [result objectForKey:@"photo"];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                
                [self imageLoaded:img];
                
            });
        });
    }
}

- (void) imageLoaded:(UIImage*) image
{
    
}

- (void) drawImage
{
    //[textView.layer addSublayer:textLayer];
    
    //view = textView;
    
    OstinPriceTag *priceTag = [[[NSBundle mainBundle] loadNibNamed:@"OstinPriceTag" owner:nil options:nil] objectAtIndex:1];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(150, 150), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, NO);
    CGContextSetAllowsAntialiasing(context, NO);
    CGContextSetShouldSmoothFonts( context , false );
    [priceTag.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *myImageData = UIImagePNGRepresentation(image);
    [fileManager createFileAtPath:@"/Users/deniskurochkin/Desktop/myimage.png" contents:myImageData attributes:nil];
}



- (void) updateItemInfo:(ItemInformation *)itemDescription
{
    _itemNameLabel.text = itemDescription.name;
    _itemArticleLabel.text = itemDescription.article;
    _barcodeLabel.text = itemDescription.barcode;
    _itemPriceLabel.text = [NSString stringWithFormat:@"%.2f %@", itemDescription.price, NSLocalizedString(@"р.", nil)];
    
    DTDevices* dtDev = [DTDevices sharedDevice];
    _printButton.enabled = (dtDev.connstate == CONN_CONNECTED) && _currentItemInfo;
    _printButtonItem.enabled = (dtDev.connstate == CONN_CONNECTED) && _currentItemInfo;
}

@end
