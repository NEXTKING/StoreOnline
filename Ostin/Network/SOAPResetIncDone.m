//
//  SOAPResetIncDone.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 10/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPResetIncDone.h"

@implementation SOAPResetIncDone

- (void)main
{
    if (self.isCancelled)
        return;
    
    [self commitOperation];
}

- (void)commitOperation
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = NO;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *request = [PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_INC_CODEVARCHAR2IN = @"all";
    request.A_ID_PORTIONNUMBERIN = @(0);
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding RESET_INC_DONEUsingSVARCHAR2_RESET_INC_DONEInput:request];
    
    if (!response.error && response.bodyParts.count > 0)
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput class]])
            self.success = YES;
        else
            self.success = NO;
    }
    else
        self.success = NO;
}

@end
