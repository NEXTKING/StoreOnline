//
//  AgentInformation.m
//  Checklines
//
//  Created by Denis Kurochkin on 11/21/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import "AgentInformation.h"

@implementation AgentInformation

- (void) dealloc
{
    [_firstName release];
    [_lastName release];
    [_email release];
    [_phone release];
    
    [super dealloc];
}

@end
