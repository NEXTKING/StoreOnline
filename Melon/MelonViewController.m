//
//  MelonViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 4/29/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MelonViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "SettingsViewController.h"
#import "BarCodeView.h"

@interface MelonViewController () <WYPopoverControllerDelegate, UIAlertViewDelegate>
{
    WYPopoverController* settingsPopover;
    NSString *temporaryCode;
    BOOL secondRequest;
    BOOL bindingInProgress;
    UIAlertView* bindingAlert;
}

@end

@implementation MelonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_barcodeSwitch.on] forKey:@"ShouldPrintBarcode"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) requestItemInfoWithCode:(NSString *)code isoType:(int)type
{
    if (bindingInProgress)
    {
        [bindingAlert textFieldAtIndex:0].text = code;
    }
    else
    {
        temporaryCode = code;
        [super requestItemInfoWithCode:code isoType:type];
    }
}

- (void) updateItemInfo:(ItemInformation *)itemInfo
{
    [super updateItemInfo:itemInfo];
    ParameterInformation *paramInfo = nil;
    ParameterInformation *stockInfo;
    for (ParameterInformation* currentParam in itemInfo.additionalParameters) {
        if ([currentParam.name isEqualToString:@"sale"])
        {
            paramInfo = currentParam;
        }
        if ([currentParam.name isEqualToString:@"stock"])
        {
            stockInfo = currentParam;
        }
    }
    
    if (paramInfo)
    {
        BOOL isSale = [paramInfo.value isEqualToString:@"1"];
        self.itemPriceLabel.backgroundColor = isSale ? [UIColor redColor]:[UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:0.28];
    }
    else
        self.itemPriceLabel.backgroundColor = [UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:0.28];
    
    if (stockInfo)
        _stockLabel.text = stockInfo.value;
        
}

- (void)clearInfo
{
    [super clearInfo];
    _stockLabel.text = @"";
    _imageView.image = nil;
}

- (IBAction)switchAction:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:sender.on] forKey:@"ShouldPrintBarcode"];
}

- (IBAction)stepperAction:(UIStepper*)sender
{
    _copiesLabel.text = [NSString stringWithFormat:@"Количество копий: %.0f", sender.value];
    self.numberOfCopies = sender.value;
    self.shouldRetrack = (self.numberOfCopies > 1);
}

- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (result == 0)
    {
        [super itemDescriptionComplete:result itemDescription:itemDescription];
        
        _revaluationLabel.hidden = secondRequest;
        
        if(secondRequest)
            secondRequest = NO;
    }
    else if (result == 1)
    {

        if (secondRequest)
        {
            [super itemDescriptionComplete:result itemDescription:itemDescription];
            secondRequest = NO;
            return;
        }
        secondRequest = YES;
        _revaluationLabel.hidden = YES;
        [self.loadingActivity startAnimating];
        [[MCPServer instance] inventoryItemDescription:self itemCode:temporaryCode];
    }
        
}

- (void) bindPrinter
{
    bindingInProgress = YES;
    bindingAlert = [[UIAlertView alloc] initWithTitle:@"Привязка принтера" message:@"Отсканируйте или введите штрих-код принтера" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Оk", nil];
    bindingAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[bindingAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    bindingAlert.tag = 987;
    [bindingAlert show];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MelonPopover"])
    {
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        
        SettingsViewController* destinationViewController = (SettingsViewController *)segue.destinationViewController;
        destinationViewController.preferredContentSize = CGSizeMake(200, 280);       // Deprecated in iOS7. Use 'preferredContentSize' instead.
        destinationViewController.feedPaperAction = ^{
            [self leftButtonAction:nil];
            [settingsPopover dismissPopoverAnimated:YES];
        };
        destinationViewController.calibrateAction = ^{
            [self calibrateAction:nil];
            [settingsPopover dismissPopoverAnimated:YES];
        };
        destinationViewController.bindPrinterAction = ^
        {
            [self bindPrinter];
            [settingsPopover dismissPopoverAnimated:YES];
        };
        destinationViewController.temporaryFeedAction = ^
        {
            [self retractAction:nil];
            [settingsPopover dismissPopoverAnimated:YES];
        };
        
        settingsPopover = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        //popoverController.delegate = self;
    }
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


- (void) startLoadingImage:(NSString *)imageName
{
    _imageView.image = [UIImage imageNamed:imageName];
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
