//
//  SOAPOperation.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 08/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPOperation.h"

@interface SOAPOperation()
{
    
}

@end

@implementation SOAPOperation


- (void) main
{
    if (self.isCancelled)
        return;
    
    
    numberOfPortions = [self getPortions:_incValue];
    
    if (numberOfPortions == 0)
        self.success = YES; // Nothing to download
    
    if (self.isCancelled || numberOfPortions <= 0)
        return;
    
    
    while (numberOfPortions > 0) {
        
        NSArray* items = [self downloadItems];
        
        if (self.isCancelled || !items)
            return;
        
        BOOL localSuccess = NO;
        localSuccess = [self saveItems:items];
        
        if (!localSuccess || self.isCancelled)
            return;
        
        localSuccess = [self commitPortion:_incValue portionID:@(currentPortionID)];
        
        if (!localSuccess || self.isCancelled)
            return;
        
        numberOfPortions--;
    }
    
    self.success = YES;

}

- (NSArray*) downloadItems
{
    return @[];
}

- (BOOL) saveItems:(NSArray *)items
{
    return YES;
}


- (NSInteger) getPortions:(NSString*) code
{
    __block NSInteger count = -1;
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = YES;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput* request = [PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput new];
    
    request.A_INC_CODEVARCHAR2IN = code;
    request.A_DEVICE_UIDVARCHAR2IN = _deviceID;
    request.A_TOTAL_SIZE_KBNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT new];
    request.A_STR_COUNTNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT new];
    request.A_COUNTNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT new];
    
    [binding.customHeaders setObject:_authValue forKey:@"Authorization"];
    
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse* response = [binding GET_PORTION_INFOUsingGET_PORTION_INFOInput:request];
    
    if (response.bodyParts.count < 1 || response.error)
        return -1;
    
    if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput class]])
    {
        PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput *output = response.bodyParts[0];
        count = output.A_COUNT.integerValue;
    }
    
    return count;
    
}

- (BOOL) commitPortion:(NSString*) incCode portionID:(NSNumber*) portion
{
    BOOL success = NO;
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = YES;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput* request = [PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput new];
    
    request.A_INC_CODEVARCHAR2IN    = incCode;
    request.A_ID_PORTIONNUMBERIN    = portion;
    request.A_DEVICE_UIDVARCHAR2IN  = _deviceID;
    
    [binding.customHeaders setObject:_authValue forKey:@"Authorization"];
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse* response = [binding SET_INC_DONEUsingSVARCHAR2_SET_INC_DONEInput:request];
    
    if (response.bodyParts.count < 1 || response.error)
        return NO;
    
    if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput class]])
    {
        PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput *output = response.bodyParts[0];
        success = [output.RETURN isEqualToString:@"SUCCESS"];
    }
    
    
    return success;
}

- (NSArray*) removeQuotes:(NSArray*) values
{
    NSMutableArray* noQuotes = [NSMutableArray new];
    
    for (int i = 0; i < values.count; ++i) {
        NSString* sourceString = values[i];
        NSString* cleanString  = [sourceString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [noQuotes addObject:cleanString];
    }
    
    return noQuotes;
}


@end
