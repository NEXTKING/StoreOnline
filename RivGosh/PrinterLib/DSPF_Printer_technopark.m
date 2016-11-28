//
//  DSPF_Printer_technopark.m
//  dphHermes
//
//  Created by Denis Kurochkin on 11.12.15.
//
//

#import "DSPF_Printer_technopark.h"
#import "MoebiusPrinterManager.h"
#import "ItemInformation.h"
#import "DTDevices.h"

@interface NSUserDefaults (Additions)
+ (NSString *) currentPrinterID;
+ (void) setCurrentPrinterID: (NSString*) printerID;
@end

@implementation NSUserDefaults(Additions)

static NSString * const NSUserDefaultsPrinterIdKey = @"PrinterID";
static NSString * const NSUserDefaultsPrinterAddressKey = @"PrinterAddress";

+ (void)setSystemValue:(id )value forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (NSString*) currentPrinterID
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:NSUserDefaultsPrinterIdKey];
}

+ (void) setCurrentPrinterID:(NSString *)printerID
{
    return [NSUserDefaults setSystemValue:printerID forKey:NSUserDefaultsPrinterIdKey];
}


+ (NSString*) currentPrinterAddress
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:NSUserDefaultsPrinterAddressKey];
}

+ (void) setCurrentPrinterAddress:(NSString *)printerAddress
{
    return [NSUserDefaults setSystemValue:printerAddress forKey:NSUserDefaultsPrinterAddressKey];
}

@end

typedef enum PrintingTask
{
    PTNone = 0,
    PTReceipt = 1,
    PTXReport = 2,
    PTZReport = 3,
    PTOpenShift = 4,
    PTRealReceipt = 5
    
}PrintingTask;

@interface DSPF_Printer_technopark () <MoebiusPrinterManagerProtocol, DTDeviceDelegate, UIAlertViewDelegate>
{
    MoebiusPrinterManager *printerManager;
    NSInteger lastErrorCode;
    DTDevices *dtDev;
    BOOL bluetoothStopFlag;
    PrintingTask currentTask;
}

@property (nonatomic, copy) NSString* printerId;
@property (nonatomic, copy) NSString* discoveredPrinter;
@property (nonatomic, strong) NSArray* currentTransportGroup;
@property (nonatomic, copy) NSString* currentSampleAmount;

@end

@implementation DSPF_Printer_technopark

- (id) init
{
    self = [super init];
    if(self)
    {
        printerManager = [MoebiusPrinterManager new];
        [dtDev addDelegate:self];
        lastErrorCode = 0;
        dtDev = [DTDevices sharedDevice];
        bluetoothStopFlag = NO;
        currentTask = PTNone;
        
        [NSUserDefaults setCurrentPrinterID:@"00019"];
        [NSUserDefaults setCurrentPrinterAddress:@"1000E8D276ED"];
        
    }
    
    return self;
}


- (void) showAlert:(NSString*)title message: (NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Interface Methods

- (void) tryConnectAndPrint
{
    
    if (dtDev.btConnectedDevices.count > 0)
        [self doPrinting];
    else if (![NSUserDefaults currentPrinterID])
        [self bindPrinterWithId:[NSUserDefaults currentPrinterID]];
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (dtDev.btConnectedDevices.count < 1 && !bluetoothStopFlag) {
                [dtDev btConnect:[NSUserDefaults currentPrinterAddress] pin:@"0000" error:nil];
            }
            
            if (bluetoothStopFlag)
                return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self doPrinting];
            });
        });
    }
}

- (void) printTransportGroup:(NSArray *)transportGroup
{
    bluetoothStopFlag = NO;
    currentTask = PTRealReceipt;
    self.currentTransportGroup = transportGroup;
    [self tryConnectAndPrint];
}

- (void) printSample:(NSString *)amount
{
    bluetoothStopFlag = NO;
    self.currentSampleAmount = amount;
    currentTask = PTReceipt;
    [self tryConnectAndPrint];
    
}

- (void) xReport
{
    bluetoothStopFlag = NO;
    currentTask = PTXReport;
    [self tryConnectAndPrint];
}

- (void) zReport
{
    bluetoothStopFlag = NO;
    currentTask = PTZReport;
    [self tryConnectAndPrint];
}

- (void) openShift
{
    bluetoothStopFlag = NO;
    currentTask = PTOpenShift;
    [self tryConnectAndPrint];
}

- (void) bindPrinterWithId:(NSString *)printerId
{
    //[self showAlert:@"Discover started" message:printerId];
    
    [dtDev addDelegate:self];
    
    bluetoothStopFlag = NO;
    self.discoveredPrinter = nil;
    
    self.printerId = printerId;
    
    NSError* error = nil;
    [dtDev btDiscoverDevicesInBackground:5 maxTime:5 codTypes:0 error:&error];
    if (error)
    {
        if (_delegate)
            [_delegate printerController:self didFailedBindingWithError:error];
    }
    
}

- (void) stopActivities
{
    bluetoothStopFlag = YES;
}

#pragma mark - DtDevice Delegate

- (void) bluetoothDeviceDiscovered:(NSString *)address name:(NSString *)name
{
    BOOL hasZebraPrefix     = NO;
    BOOL hasSerialPrefix    = NO;
    NSRange zebraRange  = [name rangeOfString:@"ZEBRA"];
    NSRange serialRange = [name rangeOfString:_printerId];
    
    hasZebraPrefix  = (zebraRange.location != NSNotFound);
    hasSerialPrefix = (serialRange.location != NSNotFound);
    
   // [self showAlert:@"Device discovered" message:name];
    
    if (hasZebraPrefix && hasSerialPrefix)
    {
        NSError* error = nil;
        self.discoveredPrinter = name;
        [dtDev btConnect:address pin:@"0000" error:&error];
        if (error)
        {
            if (currentTask == PTNone)
                [_delegate printerController:self didFailedBindingWithError:error];
            else
                [self bindPrinterWithId:[NSUserDefaults currentPrinterID]];
        }
    }
}

- (void) bluetoothDeviceConnected:(NSString *)address
{
    if (currentTask != PTNone)
    {
        [self doPrinting];
        return;
    }
    
    if (_delegate && currentTask == PTNone)
    {
        NSString *deviceName = [dtDev btGetDeviceName:address error:nil];
        [NSUserDefaults setCurrentPrinterID:deviceName];
        [NSUserDefaults setCurrentPrinterAddress:address];
        [_delegate printerController:self DidFinishBindingPrinter:deviceName];
    }
}

- (void) bluetoothDeviceDisconnected:(NSString *)address
{
    //[self showAlert:@"Discover disconnected" message:[NSString stringWithFormat:@"%@", address]];
}

- (void) bluetoothDiscoverComplete:(BOOL)success
{
    //[self showAlert:@"Discover complete" message:[NSString stringWithFormat:@"%d", success]];
    
    if (!success)
    {
        if (_delegate && currentTask == PTNone)
            [_delegate printerController:self didFailedBindingWithError:nil];
        if (currentTask != PTNone)
            [self bindPrinterWithId:[NSUserDefaults currentPrinterID]];
    }
    
    if (!self.discoveredPrinter && !bluetoothStopFlag)
    {
        [self bindPrinterWithId:_printerId];
    }
}

#pragma mark - Printer Manager Delegate

- (void) moebiusPrinterDidFinishPrinting:(MoebiusPrinterManager *)printer
{
    currentTask = PTNone;
}

- (void) doPrinting
{
    //currentActivity.alertView.message = @"Выполняется печать...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSInteger returnCode = 0;
        
        if (!printerManager)
            printerManager = [MoebiusPrinterManager new];
        
        switch (currentTask) {
            case PTXReport:
                returnCode = [printerManager xReport];
                break;
            case PTZReport:
                returnCode = [printerManager zReport];
                break;
            case PTReceipt:
                if (![printerManager isShiftOpen])
                {
                    
                    NSString *lastName = @"Кассир";
                    returnCode = [printerManager openShift:lastName];
                }
                returnCode = [printerManager sampleReceipt:[_currentSampleAmount doubleValue]];
                break;
            case PTOpenShift:
            {
               
                NSString *lastName = @"Кассир";
                returnCode = [printerManager openShift:lastName];
                break;
            }
            case PTRealReceipt:
            {
                if (![printerManager isShiftOpen])
                {
                    NSString *lastName = @"Кассир";
                    returnCode = [printerManager openShift:lastName];
                    returnCode = [printerManager openShift:lastName];
                }
                
                double orderAmount = -1;
                NSArray *printerArray = [self generatePrinterArray];
                BOOL shouldPrintVariableFooter = [self shouldPrintVariableFooter:printerArray.count];
                
                returnCode = [printerManager realReceipt:[self generatePrinterArray] footer:@"" orderAmount:orderAmount giftAmount:[self calculateGiftValue] shouldPrintVarFooter:shouldPrintVariableFooter];
            }
                break;
                
            default:
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_delegate)
            {
                if (returnCode)
                    [_delegate printerController:self didFailedPrintingWithError:nil];
                else
                    [_delegate printerControllerDidPrintReceipt:self];
            }
            
            currentTask = PTNone;
            [dtDev btDisconnect:[NSUserDefaults currentPrinterAddress] error:nil];
            
            //[printerManager release];
            //printerManager = nil;
        });
        
    });
}

- (NSArray<PrintItem*>*) generatePrinterArray
{
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (ItemInformation *item in _currentTransportGroup) {
        
        double discount = 0.0;
        for (ParameterInformation *param in item.additionalParameters) {
            if ([param.name isEqualToString:@"discounts"])
            {
                NSArray* array = (NSArray*)param.value;
                NSDictionary* dict = array[0];
                discount+= [[dict objectForKey:@"Сумма"] doubleValue];
            }
        }
        
        PrintItem *printItem = [PrintItem new];
        printItem.name = item.name;
        printItem.price = item.price*[self getItemQuantity:item];
        printItem.quantiny = [self getItemQuantity:item];
        printItem.itemCode = item.article;
        printItem.discount = -discount;
        
        [array addObject:printItem];
    }
    
    return array;
}

- (NSInteger) getItemQuantity:(ItemInformation*)item
{
    for (ParameterInformation *param in item.additionalParameters) {
        if ([param.name isEqualToString:@"quantity"])
        {
            return [param.value integerValue];
        }
    }
    
    return 1;
}

- (double) calculateGiftValue
{
    return 0.0f;
}

- (BOOL) shouldPrintVariableFooter: (NSInteger) unloadedItems
{
    return NO;
}

- (void) dealloc
{
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self stopActivities];
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
