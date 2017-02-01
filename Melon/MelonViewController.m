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
#import "AppAppearance.h"

@interface MelonViewController () <WYPopoverControllerDelegate, UIAlertViewDelegate>
{
    WYPopoverController* settingsPopover;
    NSString *temporaryCode;
    BOOL secondRequest;
    BOOL bindingInProgress;
    UIAlertView* bindingAlert;
}
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *preLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *mainLabels;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation MelonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Переоценка", nil);
    
    _scrollView.backgroundColor = AppAppearance.sharedApperance.tableViewBackgroundColor;
    
    for (UILabel *label in self.preLabels)
    {
        label.font = AppAppearance.sharedApperance.tableViewCellTitle2Font;
        label.textColor = AppAppearance.sharedApperance.tableViewCellTitle1Color;
        label.text = NSLocalizedString(label.text, nil);
    }
    
    for (UILabel *label in self.mainLabels)
    {
        label.font = AppAppearance.sharedApperance.tableViewCellTitle3Font;
        label.textColor = AppAppearance.sharedApperance.tableViewCellTitle3Color;
        label.text = NSLocalizedString(label.text, nil);
    }
    
    _barcodeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ShouldPrintBarcode"];
    _copiesLabel.text = @"1";
    [self.printButton setTitle:NSLocalizedString(@"Печать", nil) forState:UIControlStateNormal];
}

- (IBAction)printButtonAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PriceTagXibName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [super printButtonAction:sender];
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
    NSDictionary *params = itemInfo.additionalParameters;

    if (params && params[@"sale"] && [params[@"sale"] isKindOfClass:[NSString class]])
    {
        BOOL isSale = [params[@"sale"] isEqualToString:@"1"];
        //self.itemPriceLabel.backgroundColor = isSale ? [UIColor redColor]:[UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:0.28];
        self.itemPriceLabel.textColor = isSale ? [UIColor redColor] : [UIColor blackColor];
    }
    else
        //self.itemPriceLabel.backgroundColor = [UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:0.28];
        self.itemPriceLabel.textColor = [UIColor blackColor];
}

- (IBAction)switchAction:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"ShouldPrintBarcode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)stepperAction:(UIStepper*)sender
{
    _copiesLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
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
    bindingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Привязка принтера", nil) message:NSLocalizedString(@"Отсканируйте или введите штрих-код принтера", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Отмена", nil) otherButtonTitles:NSLocalizedString(@"Оk", nil), nil];
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

@end
