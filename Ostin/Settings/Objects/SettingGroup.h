//
//  SettingGroup.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingAction.h"

@interface SettingGroup : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<SettingAction*>*settingActions;
@end
