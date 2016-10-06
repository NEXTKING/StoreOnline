//
//  DSPF_SideMenuCell_technopark.m
//  dphHermes
//
//  Created by Denis Kurochkin on 05.11.15.
//
//

#import "DSPF_SideMenuCell_technopark.h"

@implementation DSPF_SideMenuCell_technopark

@synthesize cellAction  = _cellAction;
@synthesize menuIcon    = _menuIcon;
@synthesize menuTitle   = _menuTitle;

- (void)awakeFromNib {
    // Initialization code
    
   // _menuTitle.textColor = [UIColor appMainFontColor];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor whiteColor];
    [self setSelectedBackgroundView:bgColorView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
