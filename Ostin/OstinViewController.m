//
//  OstinViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 23.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "OstinViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "SettingsViewController.h"
#import "ZPLGenerator.h"
#import "BarcodeFormatter.h"
#import "AsyncImageView.h"
#import "PrintServer.h"

@interface OstinViewController ()
{
    BOOL restored;
    BOOL bindingInProgress;
    UIAlertView *bindingAlert;
    WYPopoverController *settingsPopover;
    NSMutableArray* symbols;
    NSMutableString* ringBarcode;
}

@end

@implementation OstinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    _immediateSwitch.on = ([defaults valueForKey:@"PrintImmediatly"] != nil);
    _additionalLabelSwitch.on = [defaults boolForKey:@"PrintAdditionalLabel"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"00190EA20DAA" forKey:@"PrinterID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[self barcodeData:@"990023247349" type:BAR_UPC];
    //[self barcodeData:@"990025324185" type:BAR_UPC];
    //[self barcodeData:@"990025878473" type:BAR_UPC];
    
    // Do any additional setup after loading the view.
    //[[MCPServer instance] itemDescription:self itemCode:@"2792304" shopCode:nil isoType:BAR_CODE128];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults valueForKey:@"LastBarcode"] && !_externalBarcode && !self.currentItemInfo)
    {
        restored = YES;
        NSString *barcode = [defaults valueForKey:@"LastBarcode"];
        NSNumber *type = [defaults valueForKey:@"LastBarcodeType"] != nil ? [defaults valueForKey:@"LastBarcodeType"] : @(0);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BarcodeScanNotification" object:@{@"barcode":barcode,@"type":type}];
    }
    else if (_externalBarcode)
    {
        [self updateItemInfo:self.currentItemInfo];
    }
}

- (IBAction)additionalLabelSwitchDidChanged:(id)sender
{
    UISwitch *_switch = sender;
    [[NSUserDefaults standardUserDefaults] setBool:_switch.on forKey:@"PrintAdditionalLabel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) printButtonAction:(id)sender
{
    NSString *str = [[NSBundle mainBundle] pathForResource:@"label" ofType:@"zpl"];
    NSString *addStr = [[NSBundle mainBundle] pathForResource:@"producer_label" ofType:@"zpl"];
    [[PrintServer instance] addItemToPrintQueue:self.currentItemInfo printFormat:str];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PrintAdditionalLabel"])
        [[PrintServer instance] addItemToPrintQueue:self.currentItemInfo printFormat:addStr];
}

- (void)printerDidFinishPrinting
{
    
}

- (void)printerDidFailPrinting:(NSError *)error
{
    
}

- (IBAction)manualInputAction:(id)sender
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Ручной ввод"
                                                                   message:@"Введите код товара или код производителя"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) wself = self;
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Отправить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        NSString *text = alert.textFields[0].text;
        text.length > 10 ? [wself requestItemInfoWithCode:text isoType:0] : [wself requestItemInfoWithArticle:text];
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField* textField) {}];
    
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanNotification:(NSNotification*)aNotification
{
    if (bindingInProgress)
    {
        NSString* code = [aNotification.object objectForKey:@"barcode"];
        [bindingAlert textFieldAtIndex:0].text = code;
        return;
    }
    if (aNotification.object != nil)
	{
    	lastBarcode = [aNotification.object objectForKey:@"barcode"];
    	NSNumber *type = [aNotification.object objectForKey:@"type"];
    	[[NSUserDefaults standardUserDefaults] setValue:lastBarcode forKey:@"LastBarcode"];
    
    	NSString *internalBarcode = [BarcodeFormatter normalizedBarcodeFromString:lastBarcode isoType:type.intValue];
    	[self requestItemInfoWithCode:internalBarcode isoType:type.intValue];
	}
}

- (void) requestItemInfoWithCode:(NSString *)code isoType:(int)type
{
    _imageView.image = nil;
    [super requestItemInfoWithCode:code isoType:type];
    self.itemPriceLabel.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:0.28];
}

- (void) requestItemInfoWithArticle:(NSString *)article
{
    _imageView.image = nil;
    [self.loadingActivity startAnimating];
    [[MCPServer instance] itemDescription:self article:article];
    self.itemPriceLabel.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:0.28];
}

- (void) updateItemInfo:(ItemInformation *)itemInfo
{
    [super updateItemInfo:itemInfo];
    
    NSString *urlString = [itemInfo additionalParameterValueForName:@"imageURL"];
    _imageView.image = [UIImage imageNamed:@"no-image.png"];
    _imageView.imageURL = [NSURL URLWithString:urlString];
    
    double retailPrice = [[itemInfo additionalParameterValueForName:@"retailPrice"] doubleValue];
    self.itemPriceLabel.text = [NSString stringWithFormat:@"%.2f р.", MIN(itemInfo.price, retailPrice)];
}

- (void) compareAmount:(ItemInformation *)itemInfo
{
    NSDictionary *data = [BarcodeFormatter dataFromBarcode:lastBarcode isoType:BAR_CODE128];
    if (data != nil)
    {
        double barcodePrice = [data[@"price"] doubleValue];
        double itemCatalogPrice = itemInfo.price;
        double itemRetailPrice = [[itemInfo additionalParameterValueForName:@"retailPrice"] doubleValue];
        [self amountCompareCompleted:(barcodePrice == MIN(itemRetailPrice, itemCatalogPrice))];
    }
    else
        [self amountCompareCompleted:NO];
}

- (void) amountCompareCompleted:(BOOL)isEqual
{
    if (!isEqual && !restored)
    {
        DTDevices *dtDev = [DTDevices sharedDevice];
        int beepData[]={1000,200,1000,200};
        [dtDev playSound:100 beepData:beepData length:sizeof(beepData) error:nil];
        /*int beepData[]={660,100,0,150,660,100,0,300,660,100,0,300};
        //
        [dtDev playSound:100 beepData:beepData length:sizeof(beepData) error:nil];
        
        __block double delay = 1.05;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int beepData1[] = {510,100,0,100,660,100,0,300,770,100};
            [dtDev playSound:100 beepData:beepData1 length:sizeof(beepData1) error:nil];
        });
        
        delay += 1.25;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int beepData1[] = {380,100,0,575,510,100,0,450,380,100};
            [dtDev playSound:100 beepData:beepData1 length:sizeof(beepData1) error:nil];
        });
        
        delay += 0.4;
        delay += 0.775;
        delay += 0.55;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int beepData1[] = {320,100,0,500,440,100,0,300,480,80};
            [dtDev playSound:100 beepData:beepData1 length:sizeof(beepData1) error:nil];
        });
        
        delay+=0.33;
        delay+=1.08;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int beepData1[] = {450,100,0,150,430,100,0,300,380,100};
            [dtDev playSound:100 beepData:beepData1 length:sizeof(beepData1) error:nil];
        });
        
        delay+=0.2;
        delay+=0.75;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int beepData1[] = {660,80, 0,200,760,50, 0,150, 860,100};
            [dtDev playSound:100 beepData:beepData1 length:sizeof(beepData1) error:nil];
        });
        
        delay+=0.3;
        delay+=0.58;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int beepData1[] = {700,80,0,150,760,50,0,350,660,80};
            [dtDev playSound:100 beepData:beepData1 length:sizeof(beepData1) error:nil];
        });
         
        */
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults valueForKey:@"PrintImmediatly"])
        {
            [self.printButton sendActionsForControlEvents: UIControlEventTouchUpInside];
        }
        //,0,400,320,100,0,500
    }
    else if (isEqual && !restored)
    {
        DTDevices *dtDev = [DTDevices sharedDevice];
        int data[]={300,70,500,70,700,70,900,70};
        [dtDev playSound:100 beepData:data length:sizeof(data) error:nil];
    }
    
    self.amountStatusLabel.text = isEqual ? @"✓" : @"✕";
    self.amountStatusLabel.backgroundColor = isEqual ? [UIColor colorWithRed:0 green:180/255.0 blue:0 alpha:0.3] : [UIColor redColor];
    self.itemPriceLabel.backgroundColor = isEqual ? [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:0.28]:[UIColor redColor];
    restored = NO;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"MelonPopover"])
    {
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        
        SettingsViewController* destinationViewController = (SettingsViewController *)segue.destinationViewController;
        destinationViewController.preferredContentSize = CGSizeMake(200, 180);       // Deprecated in iOS7. Use 'preferredContentSize' instead.
               
        settingsPopover = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        
        destinationViewController.bindPrinterAction = ^
        {
            [self bindPrinter];
            [settingsPopover dismissPopoverAnimated:YES];
        };
        
        destinationViewController.feedPaperAction = ^
        {
            [self feedPaper];
            [settingsPopover dismissPopoverAnimated:YES];
            
        };
        //popoverController.delegate = self;
    }
    
}

- (void) feedPaper
{
    self.currentZPLInfo = [NSData data];
    [super printButtonAction:nil];
}

- (void) bindPrinter
{
    bindingInProgress = YES;
    bindingAlert = [[UIAlertView alloc] initWithTitle:@"Привязка принтера" message:@"Отсканируйте или введите штрих-код принтера" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Оk", nil];
    bindingAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [bindingAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    bindingAlert.tag = 987;
    [bindingAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        
        if (alertView.tag == 987)
        {
            NSString* barcode = [[alertView textFieldAtIndex:0] text];
            [[NSUserDefaults standardUserDefaults] setValue:barcode forKey:@"PrinterID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 987)
        bindingInProgress = NO;
}


@end
