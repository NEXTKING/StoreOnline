//
//  DPCaseStatusIndicatorView.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 13/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "DPCaseStatusIndicatorView.h"
#import "DTDevices.h"

@interface DPCaseStatusIndicatorView()<DTDeviceDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation DPCaseStatusIndicatorView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initializeViews];
    
    DTDevices *dtdev = [DTDevices sharedDevice];
    [self connectionState:dtdev.connstate];
    [dtdev addDelegate:self];
}

- (void)dealloc
{
    DTDevices *dtdev = [DTDevices sharedDevice];
    [dtdev removeDelegate:self];
}

- (void)initializeViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.imageView];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.font = [UIFont fontWithName:@"Roboto-Thin" size:10];
    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.statusLabel];
    
    NSDictionary *views = @{ @"im":self.imageView, @"label": self.statusLabel };
    NSString *format = [NSString stringWithFormat:@"H:|-0-[label]-%@-[im(==20)]-1-|", (_showDisconectLabel ? @"8" : @"1")];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatDirectionLeftToRight metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.statusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)connectionState:(int)state
{
    switch (state)
    {
        case CONN_CONNECTED:
            [self setSuccessState];
            break;
        case CONN_CONNECTING:
            [self setFailState];
            break;
        case CONN_DISCONNECTED:
            [self setFailState];
            break;
        default:
            break;
    }
}

- (void)setFailState
{
    [self.imageView setImage:[UIImage imageNamed:@"off_ico"]];
    //[self.statusLabel setText:(_showDisconectLabel ? NSLocalizedString(@"Сканер не подключен", nil) : @"")];
    [self.statusLabel setText:@""];
}

- (void)setSuccessState
{
    [self.imageView setImage:[UIImage imageNamed:@"on_ico"]];
    [self.statusLabel setText:@""];
}

@end
