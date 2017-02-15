//
//  SettingAction.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 15/02/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SettingAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *nibIdentifier;
@property (nonatomic, copy) void (^action)();
@property (nonatomic, copy) void (^updateCell)();
@property (nonatomic, weak) UITableViewCell *cell;
@property (nonatomic, weak) UIViewController *delegateViewController;

@end
