//
//  RegisterParams.m
//  Checklines
//
//  Created by Denis Kurochkin on 12.10.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "RegisterParams.h"

@implementation RegisterParams

- (void) dealloc
{
    [_phone release];
    [_password release];
    [_firstName release];
    [_lastName release];
    [_email release];
    [super dealloc];
}

@end
