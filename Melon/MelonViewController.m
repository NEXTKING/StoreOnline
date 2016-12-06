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

@interface MelonViewController () <WYPopoverControllerDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    WYPopoverController* settingsPopover;
    NSString *temporaryCode;
    BOOL secondRequest;
    BOOL bindingInProgress;
    UIAlertView* bindingAlert;
    UIPickerView *_priceTagTypePicker;
    NSArray<NSDictionary*> *_priceTagTypes;
}

@end

@implementation MelonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initChangePriceTagTypePicker];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"ShouldPrintBarcode"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShouldPrintBarcode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _barcodeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldPrintBarcode"];
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
    for (ParameterInformation* currentParam in itemInfo.additionalParameters) {
        if ([currentParam.name isEqualToString:@"sale"])
        {
            paramInfo = currentParam;
            break;
        }
    }
    
    if (paramInfo)
    {
        BOOL isSale = [paramInfo.value isEqualToString:@"1"];
        self.itemPriceLabel.backgroundColor = isSale ? [UIColor redColor]:[UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:0.28];
    }
    else
        self.itemPriceLabel.backgroundColor = [UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:0.28];
        
}

- (IBAction)switchAction:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"ShouldPrintBarcode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - price tag type

- (void)initChangePriceTagTypePicker
{
    _priceTagTypes = @[@{@"name":@"48x48 мм", @"xibName":@"MelonPriceTag48x48"},
                       @{@"name":@"30x60 мм", @"xibName":@"MelonPriceTag30x60"},
                       @{@"name":@"29x28 мм", @"xibName":@"MelonPriceTag29x28"}];
    
    NSString *xibName = [[NSUserDefaults standardUserDefaults] valueForKey:@"PriceTagXibName"];
    __block NSUInteger index = 0;
    if (xibName != nil)
    {
        [_priceTagTypes indexOfObjectPassingTest:^BOOL(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            
            if ([obj[@"xibName"] isEqualToString:xibName])
            {
                index = idx;
                return (*stop = YES);
            }
            else
                return NO;
        }];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:_priceTagTypes[index][@"xibName"] forKey:@"PriceTagXibName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _priceTagTypeLabel.text = [NSString stringWithFormat:@"Тип этикетки: %@", _priceTagTypes[index][@"name"]];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangePriceTagType:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Выбрать" style:UIBarButtonItemStyleDone target:self action:@selector(doneChangePriceTagType:)];
    toolBar.items = @[cancelButton, flexibleSpace, doneButton];
    
    _priceTagTypePicker = [[UIPickerView alloc] init];
    _priceTagTypePicker.delegate = self;
    _priceTagTypePicker.dataSource = self;
    
    _priceTagChangeTypeTextField.inputView = _priceTagTypePicker;
    _priceTagChangeTypeTextField.inputAccessoryView = toolBar;
    _priceTagChangeTypeTextField.tintColor = [UIColor clearColor];
    _priceTagChangeTypeTextField.layer.cornerRadius = 3;
    _priceTagChangeTypeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _priceTagChangeTypeTextField.layer.borderWidth = 1;
}

- (void)cancelChangePriceTagType:(id)sender
{
    [_priceTagChangeTypeTextField resignFirstResponder];
}

- (void)doneChangePriceTagType:(id)sender
{
    NSUInteger type = [_priceTagTypePicker selectedRowInComponent:0];
    [[NSUserDefaults standardUserDefaults] setValue:_priceTagTypes[type][@"xibName"] forKey:@"PriceTagXibName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _priceTagTypeLabel.text = [NSString stringWithFormat:@"Тип этикетки: %@", _priceTagTypes[type][@"name"]];
    [_priceTagChangeTypeTextField resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _priceTagTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _priceTagTypes[row][@"name"];
}

@end
