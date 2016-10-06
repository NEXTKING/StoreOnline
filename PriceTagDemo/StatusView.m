//
//  StatusView.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 03.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "StatusView.h"
#import "DTDevices.h"

@interface StatusView () <DTDeviceDelegate>

@end

@implementation StatusView

- (void) internalInit
{
    DTDevices* dtDev = [DTDevices sharedDevice];
    [dtDev addDelegate:self];
    self.layer.cornerRadius = self.frame.size.height/2;
}

- (void) awakeFromNib
{
    [self internalInit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) connectionState:(int)state
{
    switch (state) {
        case CONN_CONNECTED:
        {
            self.backgroundColor = [UIColor greenColor];
            
        }
            break;
        case CONN_CONNECTING:
            self.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
        case CONN_DISCONNECTED:
            self.backgroundColor = [UIColor redColor];
            //_printerStatusLabel.hidden = YES;
            break;
            
        default:
            break;
    }

    //_searchPrinterButton.enabled = (state == CONN_CONNECTED);
}




@end
