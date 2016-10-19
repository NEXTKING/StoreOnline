//
//  AppDelegate.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21.01.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AppDelegate.h"
#import "DTDevices.h"

@interface AppDelegate () <DTDeviceDelegate>
{
    int _networkIndicatorCounter;
    NSMutableArray* symbols;
    NSMutableString* ringBarcode;
    NSString *ringBarcodeType;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    DTDevices *dtDevice = [DTDevices sharedDevice];
    [dtDevice addDelegate:self];
    [dtDevice connect];
    [self initializeRing];
    
#ifdef DESONDO
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"desondo.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor blackColor]];
#elif defined (RIVGOSH)
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"rivgosh.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.workspace = [[DSPF_Workspace alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationCont"];
    _workspace.navigationController = rootViewController;
    [self.window setRootViewController:_workspace];
    [self.window makeKeyAndVisible];
#elif defined (OSTIN)
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation.png"] forBarMetrics:UIBarMetricsDefault];
    
#elif defined (MELON)
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"MFG_Bar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
#elif defined (X5)
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor clearColor]}];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"x5Bar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1.0]];
#endif
    
     //NSString *settingsString = [[NSUserDefaults standardUserDefaults] valueForKey:@"host_preference"];
    //if (!settingsString)
        [self registerDefaultsFromSettingsBundle];
    
    return YES;
}

- (void) connectionState:(int)state
{
    switch (state) {
        case CONN_CONNECTED:
        {
            
            DTDevices *dtDevice = [DTDevices sharedDevice];
            [dtDevice emsrConfigMaskedDataShowExpiration:TRUE showServiceCode:TRUE showTrack3:FALSE unmaskedDigitsAtStart:6 unmaskedDigitsAtEnd:2 unmaskedDigitsAfter:7 error:nil];
            [dtDevice emsrSetEncryption:7 keyID:2 params:nil error:nil];
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"ScanSoundEnabled"])
            {
                int beep2[]={2730,250};
                [dtDevice barcodeSetScanBeep:YES volume:100 beepData:beep2 length:sizeof(beep2) error:nil];
            }
            
#ifdef MELON
            [dtDevice setCharging:YES error:nil];
            [dtDevice setPassThroughSync:YES error:nil];
#endif
            
            //[dtDevice emsrConfigMaskedDataShowExpiration:TRUE showServiceCode:TRUE showTrack3:FALSE unmaskedDigitsAtStart:6 unmaskedDigitsAtEnd:2 unmaskedDigitsAfter:7 error:nil];
            //[dtDevice emsrSetEncryption:7 keyID:2 params:nil error:nil];
            //[printVC startSearchingPtinter];
            
        }
            break;
        case CONN_CONNECTING:
            //_printerStatusLabel.hidden = YES;
            break;
        case CONN_DISCONNECTED:
            //_printerStatusLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}


- (void)registerDefaultsFromSettingsBundle {
    // this function writes default settings as settings
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            //NSLog(@"writing as default %@ to the key %@",[prefSpecification objectForKey:@"DefaultValue"],key);
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    DTDevices *dtdev = [DTDevices sharedDevice];
    
    [dtdev prnRetractPaper:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /*NSString *settingsString = [[NSUserDefaults standardUserDefaults] valueForKey:@"host_preference"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings" message:settingsString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show]; */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) networkIndicatorUpdate
{
    if ( _networkIndicatorCounter <= 0 )
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _networkIndicatorCounter = 0;
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void) enableNetworkIndicator
{
    ++_networkIndicatorCounter;
    [self performSelector:@selector(networkIndicatorUpdate) withObject:Nil afterDelay:1];
}

- (void) disableNetworkIndicator
{
    --_networkIndicatorCounter;
    [self performSelector:@selector(networkIndicatorUpdate) withObject:Nil afterDelay:1];
}

#pragma mark - Scan Delegate

- (void) initializeRing
{
    symbols = [NSMutableArray new];
    
    for (int i = 0; i < 127; ++i) {
        // ASCII to NSString
        NSString *string = [NSString stringWithFormat:@"%c", i]; // A
        UIKeyCommand *command = [UIKeyCommand keyCommandWithInput:string modifierFlags:0 action:@selector(gsKey:)];
        [symbols addObject:command];
    }
    
    [symbols addObject:[UIKeyCommand keyCommandWithInput:@"A" modifierFlags:UIKeyModifierShift action:@selector(gsKey:)]];
    [symbols addObject:[UIKeyCommand keyCommandWithInput:@"D" modifierFlags:UIKeyModifierShift action:@selector(gsKey:)]];
    [symbols addObject:[UIKeyCommand keyCommandWithInput:@"4" modifierFlags:UIKeyModifierShift action:@selector(gsKey:)]];
    [symbols addObject:[UIKeyCommand keyCommandWithInput:@"$" modifierFlags:0 action:@selector(gsKey:)]];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
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
    {
        ringBarcode = [NSMutableString new];
        ringBarcodeType = @"";
    }
    else if ([keyCommand.input isEqualToString:@"#"])
    {
        int type = 0;
        if ([ringBarcodeType isEqualToString:@"A"])
            type = BAR_UPC;
        else if ([ringBarcodeType isEqualToString:@"D"])
            type = BAR_CODE128;
        else
            type  = 0;
        
        [self sendNotificationWithCode:ringBarcode type:type];
    }
    else if (ringBarcode.length == 0 && ringBarcodeType.length == 0)
        ringBarcodeType = keyCommand.input;
    else
        [ringBarcode appendString:keyCommand.input];
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    [self sendNotificationWithCode:barcode type:type];
}

- (void) barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    [self sendNotificationWithCode:barcode type:0];
}

- (void) sendNotificationWithCode:(NSString*) code type:(int) type
{
    
    if (!code)
        return;
    
    NSDictionary* params = @{@"barcode":code,@"type":@(type)};
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"BarcodeScanNotification"
     object:nil userInfo:params];
}

@end
