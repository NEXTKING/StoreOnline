//
//  AppDelegate.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 21.01.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef RIVGOSH
#import "DSPF_Workspace.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#ifdef RIVGOSH
@property (strong, nonatomic)  DSPF_Workspace* workspace;
#endif

- (void)resetWindowToInitialView;
- (void) disableNetworkIndicator;
- (void) enableNetworkIndicator;


@end

