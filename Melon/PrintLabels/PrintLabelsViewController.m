//
//  PrintLabelsViewController.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 13/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "PrintLabelsViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "SettingsViewController.h"
#import "ViewController.h"

@interface PrintLabelsViewController () <WYPopoverControllerDelegate, UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSUInteger _selectedPriceTagType;
    UIPickerView *_priceTagTypePicker;
    NSArray<NSDictionary*> *_priceTagTypes;
}
@property (weak, nonatomic) IBOutlet UILabel *priceTagTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTagChangeTypeTextField;
@end

@implementation PrintLabelsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initChangePriceTagTypePicker];
    _priceTagChangeTypeTextField.text = NSLocalizedString(@"Изменить", nil);
}

- (void) updateItemInfo:(ItemInformation *)itemInfo
{
    [super updateItemInfo:itemInfo];
    self.itemPriceLabel.textColor = [UIColor blackColor];
}

- (IBAction)printButtonAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:_priceTagTypes[_selectedPriceTagType][@"xibName"] forKey:@"PriceTagXibName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // We have a following hierarchy: ViewController<-MelonViewController<-PrintLabelsViewController(this)
    // And we need to call printButtonAction: ViewController's implementation
    void (*printMethod)(id, SEL, id) = (void (*)(id, SEL, id))[[[self superclass] superclass] instanceMethodForSelector:_cmd];
    printMethod(self, _cmd, sender);
}

#pragma mark - price tag type

- (void)initChangePriceTagTypePicker
{
    _priceTagTypes = @[@{@"name":NSLocalizedString(@"48x48 мм", nil), @"xibName":@"MelonPriceTag48x48"},
                       @{@"name":NSLocalizedString(@"30x60 мм", nil), @"xibName":@"MelonPriceTag30x60"},
                       @{@"name":NSLocalizedString(@"29x28 мм", nil), @"xibName":@"MelonPriceTag29x28"}];
    
    _selectedPriceTagType = 0;
    _priceTagTypeLabel.text = _priceTagTypes[_selectedPriceTagType][@"name"];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangePriceTagType:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Выбрать", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneChangePriceTagType:)];
    toolBar.items = @[cancelButton, flexibleSpace, doneButton];
    
    _priceTagTypePicker = [[UIPickerView alloc] init];
    _priceTagTypePicker.delegate = self;
    _priceTagTypePicker.dataSource = self;
    
    _priceTagChangeTypeTextField.inputView = _priceTagTypePicker;
    _priceTagChangeTypeTextField.inputAccessoryView = toolBar;
    _priceTagChangeTypeTextField.tintColor = [UIColor clearColor];
    _priceTagChangeTypeTextField.layer.cornerRadius = 4;
    _priceTagChangeTypeTextField.layer.borderColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1].CGColor;
    _priceTagChangeTypeTextField.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1];
    _priceTagChangeTypeTextField.textColor = [UIColor whiteColor];
}

- (void)cancelChangePriceTagType:(id)sender
{
    [_priceTagChangeTypeTextField resignFirstResponder];
}

- (void)doneChangePriceTagType:(id)sender
{
    _selectedPriceTagType = [_priceTagTypePicker selectedRowInComponent:0];
    _priceTagTypeLabel.text = _priceTagTypes[_selectedPriceTagType][@"name"];
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
