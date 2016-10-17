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


@interface OstinViewController ()
{
    BOOL restored;
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
    
    //[self barcodeData:@"990023247349" type:BAR_UPC];
    //[self barcodeData:@"990025324185" type:BAR_UPC];
    //[self barcodeData:@"990025878473" type:BAR_UPC];
    
    
    
    if ([defaults valueForKey:@"LastBarcode"] && !_externalBarcode)
    {
        restored = YES;
        [self barcodeData:[defaults valueForKey:@"LastBarcode"] type:0];
    }
    else if (_externalBarcode)
    {
        [self barcodeData:_externalBarcode type:0];
    }
    // Do any additional setup after loading the view.
    
    [self initializeRing];
    
    //[[MCPServer instance] itemDescription:self itemCode:@"2792304" shopCode:nil isoType:BAR_CODE128];
}

- (void) initializeRing
{
    symbols = [NSMutableArray new];
    
    for (int i = 0; i < 127; ++i) {
        // ASCII to NSString
        NSString *string = [NSString stringWithFormat:@"%c", i]; // A
        UIKeyCommand *command = [UIKeyCommand keyCommandWithInput:string modifierFlags:0 action:@selector(gsKey:)];
        [symbols addObject:command];
    }
}

- (NSArray *)keyCommands
{
    return symbols;
    
    // <RS> - char(30): ctrl-shift-6 (or ctrl-^)
    //UIKeyCommand *rsCommand = [UIKeyCommand keyCommandWithInput:@"6" modifierFlags:UIKeyModifierShift|UIKeyModifierControl action:@selector(rsKey:)];
    // <GS> - char(29): ctrl-]
    //UIKeyCommand *gsCommand = [UIKeyCommand keyCommandWithInput:@"]" modifierFlags:UIKeyModifierControl action:@selector(gsKey:)];
    // <EOT> - char(4): ctrl-d
    //UIKeyCommand *eotCommand = [UIKeyCommand keyCommandWithInput:@"D" modifierFlags:UIKeyModifierControl action:@selector(eotKey:)];
    //return [[NSArray alloc] initWithObjects:rsCommand, gsCommand, eotCommand, nil];
}


- (void) gsKey: (UIKeyCommand *) keyCommand {
    NSLog(@"%@", keyCommand.input);
    
    if ([keyCommand.input isEqualToString:@"$"])
        ringBarcode.string = @"";
    else if ([keyCommand.input isEqualToString:@"%"])
        [self sendNotification:nil];
    else
        [ringBarcode appendString:keyCommand.input];
}

- (IBAction)immediateSwitchAction:(UISwitch*)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id obj = sender.on?@YES:nil;
    [defaults setValue:obj forKey:@"PrintImmediatly"];
}

- (void) sendNotification:(id) sender
{
    [self barcodeData:ringBarcode type:0];
}

- (NSString*) parseBarcode:(NSString*) code
{
    if (code.length < 8)
        return nil;
   
    NSString* finalCode = [code substringFromIndex:8];
    
    if (finalCode.length < 8)
        return nil;
    
    finalCode = [finalCode substringToIndex:7];
    
    [self showInfoMessage:finalCode];
    return finalCode;
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    if (type != BAR_CODE128)
    {
        [super barcodeData:barcode type:type];
        return;
    }
    
    NSString* parsedCode = [self parseBarcode:barcode];
    
    if (!parsedCode)
        return;
    
    [super barcodeData:parsedCode type:type];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    NSString* parsedCode = [self parseBarcode:barcode];
    
    if (!parsedCode)
        return;
    
    [super barcodeData:parsedCode isotype:isotype];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestItemInfoWithCode:(NSString *)code isoType:(int)type
{
    _imageView.image = nil;
    [super requestItemInfoWithCode:code isoType:type];
    self.itemPriceLabel.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:0.28];
}

- (void) updateItemInfo:(ItemInformation *)itemInfo
{
    [super updateItemInfo:itemInfo];
    
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"no-image.png"]];
}

- (void) amountCompareCompleted:(BOOL)isEqual
{
    if (!isEqual && !restored)
    {
        DTDevices *dtDev = [DTDevices sharedDevice];
        int beepData[]={1000,300,1000,300};
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
        destinationViewController.preferredContentSize = CGSizeMake(200, 280);       // Deprecated in iOS7. Use 'preferredContentSize' instead.
               
        settingsPopover = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        //popoverController.delegate = self;
    }
    
}


@end
