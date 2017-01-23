//
//  AppAppearance.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "AppAppearance.h"
#import "DPAppearance.h"

static id<UIKitAppearanceProtocol> __inst = Nil;

@implementation AppAppearance

+ (id<UIKitAppearanceProtocol>)sharedApperance
{
    if (__inst == nil)
        __inst = [[DPAppearance alloc] init];
    
    return __inst;
}

@end
