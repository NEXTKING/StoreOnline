//
//  AppAppearance.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 11/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UIKitAppearanceProtocol <NSObject>

#pragma mark - UINavigationBar appearance

- (UIColor *)navigationBarBackgroundColor;
- (UIColor *)navigationBarTintColor;
- (BOOL)navigationBarisTranslucent;

- (UIImage *)navigationBarBackButtonImage;
- (UIImage *)navigationBarSendButtonImage;
- (UIImage *)navigationBarManualInputImage;

#pragma mark - UITableView appearance

- (UIColor *)tableViewSeparatorColor;
- (UITableViewCellSeparatorStyle)tableViewSeparatorStyle;
- (UIColor *)tableViewBackgroundColor;

#pragma mark - UITableViewSectionHeader appearance

- (UIColor *)tableViewSectionHeaderBackgroundColor;

- (UIFont *)tableViewSectionHeaderTitle1Font;
- (UIColor *)tableViewSectionHeaderTitle1Color;

- (UIFont *)tableViewSectionHeaderTitle2Font;
- (UIColor *)tableViewSectionHeaderTitle2Color;

- (UIFont *)tableViewSectionHeaderTitle3Font;
- (UIColor *)tableViewSectionHeaderTitle3Color;

#pragma mark - UITableViewCell appearance

- (UIColor *)tableViewCellBackgroundColor;
- (UIColor *)tableViewCellSelectedBackgroundColor;
- (UIColor *)tableViewCellBackgroundGreenColor;
- (UIColor *)tableViewCellBackgroundRedColor;

- (UIFont *)tableViewCellTitle1Font;
- (UIColor *)tableViewCellTitle1Color;
- (UIColor *)tableViewCellTitle1SelectedColor;

- (UIFont *)tableViewCellTitle2Font;
- (UIColor *)tableViewCellTitle2Color;
- (UIColor *)tableViewCellTitle2SelectedColor;

- (UIFont *)tableViewCellTitle3Font;
- (UIColor *)tableViewCellTitle3Color;
- (UIColor *)tableViewCellTitle3SelectedColor;

- (UIView *)tableViewCellDisclosureIndicatorView;
- (CGRect)tableViewCellDisclosureIndicatorViewFrame;

#pragma mark - UIButton appearance

- (UIFont *)buttonTitleLabelFont;
- (UIColor *)buttonTitleLabelNormalColor;
- (UIColor *)buttonTitleLabelHighlightedColor;

@end

@interface AppAppearance : NSObject

+ (id<UIKitAppearanceProtocol>)sharedApperance;

@end
