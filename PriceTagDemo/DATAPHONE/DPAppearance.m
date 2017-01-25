//
//  DPAppearance.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 10/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "DPAppearance.h"

@implementation DPAppearance

#pragma mark - UINavigationBar appearance

- (UIColor *)navigationBarBackgroundColor
{
    return [UIColor whiteColor];
}

- (UIColor *)navigationBarTintColor
{
    return [UIColor blackColor];
}

- (BOOL)navigationBarisTranslucent
{
    return NO;
}

- (UIImage *)navigationBarBackButtonImage
{
    return [[UIImage imageNamed:@"back_ico"] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, -2, 0)];
}

- (UIImage *)navigationBarSendButtonImage
{
    return [UIImage imageNamed:@"send_ico"];
}

- (UIImage *)navigationBarManualInputImage
{
    return [[UIImage imageNamed:@"kod_ico"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - UITableView appearance

- (UIColor *)tableViewSeparatorColor
{
    return [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
}

- (UITableViewCellSeparatorStyle)tableViewSeparatorStyle
{
    return UITableViewCellSeparatorStyleSingleLine;
}

- (UIColor *)tableViewBackgroundColor
{
    return [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
}

#pragma mark - UITableViewSectionHeader appearance

- (UIColor *)tableViewSectionHeaderBackgroundColor
{
    return [UIColor colorWithRed:26.0/255.0 green:155.0/255.0 blue:237.0/255.0 alpha:1];
}

- (UIFont *)tableViewSectionHeaderTitle1Font
{
    return [UIFont fontWithName:@"Roboto-Light" size:15];
}

- (UIColor *)tableViewSectionHeaderTitle1Color
{
    return [UIColor whiteColor];
}

- (UIFont *)tableViewSectionHeaderTitle2Font
{
    return [UIFont fontWithName:@"Roboto-Light" size:12];
}

- (UIColor *)tableViewSectionHeaderTitle2Color
{
    return [UIColor whiteColor];
}

- (UIFont *)tableViewSectionHeaderTitle3Font
{
    return [UIFont fontWithName:@"Roboto-Thin" size:12];
}

- (UIColor *)tableViewSectionHeaderTitle3Color
{
    return [UIColor whiteColor];
}

#pragma mark - UITableViewCell appearance

- (UIColor *)tableViewCellBackgroundColor
{
    return [self tableViewBackgroundColor];
}

- (UIColor *)tableViewCellSelectedBackgroundColor
{
    return [UIColor colorWithRed:26.0/255.0 green:155.0/255.0 blue:237.0/255.0 alpha:1];
}

- (UIColor *)tableViewCellBackgroundGreenColor
{
    return [UIColor colorWithRed:126/255.0 green:211/255.0 blue:33/255.0 alpha:0.2];
}

- (UIColor *)tableViewCellBackgroundRedColor
{
    return [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
}

- (UIFont *)tableViewCellTitle1Font
{
    return [UIFont fontWithName:@"Roboto-Thin" size:15];
}

- (UIColor *)tableViewCellTitle1Color
{
    return [UIColor blackColor];
}

- (UIColor *)tableViewCellTitle1SelectedColor
{
    return [UIColor whiteColor];
}

- (UIFont *)tableViewCellTitle2Font
{
    return [UIFont fontWithName:@"Roboto-Thin" size:11];
}

- (UIColor *)tableViewCellTitle2Color
{
    return [UIColor blackColor];
}

- (UIColor *)tableViewCellTitle2SelectedColor
{
    return [UIColor whiteColor];
}

- (UIFont *)tableViewCellTitle3Font
{
    return [UIFont fontWithName:@"Roboto-Light" size:15];
}

- (UIColor *)tableViewCellTitle3Color
{
    return [UIColor blackColor];
}

- (UIColor *)tableViewCellTitle3SelectedColor
{
    return [UIColor whiteColor];
}

- (UIView *)tableViewCellDisclosureIndicatorView
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow1_ico"]];
}

- (CGRect)tableViewCellDisclosureIndicatorViewFrame
{
    return CGRectMake(0, 0, 5, 9);
}

#pragma mark - UIButton appearance

- (UIFont *)buttonTitleLabelFont
{
    return [UIFont fontWithName:@"Roboto-Thin" size:15];
}

- (UIColor *)buttonTitleLabelNormalColor
{
    return [UIColor colorWithRed:0 green:122.0/255.0 blue:1 alpha:1];
}

- (UIColor *)buttonTitleLabelHighlightedColor
{
    return [UIColor colorWithRed:0 green:60.0/255.0 blue:128.0/255.0 alpha:1];
}

@end
