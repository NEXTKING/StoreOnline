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
    _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_privateContext setParentContext:_dataController.managedObjectContext];
    
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
        
        __block BOOL localSuccess = NO;
        
        [_privateContext performBlockAndWait:^{
            localSuccess = [self saveItems:items];
            
            if (localSuccess)
            {
                [self.dataController.managedObjectContext performBlockAndWait:^{
                
                    localSuccess = [_dataController.managedObjectContext save:nil];
            
                }];
            }
        }];
    
        
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
    for (PI_MOBILE_SERVICEService_TROW_IntType *throw in items)
    {
        NSArray *csvSourse = [throw.VAL componentsSeparatedByString:@";"];
        NSArray *csv       = [self removeQuotes:csvSourse];
        
        if (csv.count < 1)
            return NO;
        
        NSString* incrementValue = csv[0];
        NSManagedObject* coreDataObject = nil;
        
        if ([incrementValue isEqualToString:@"I"])
        {
           coreDataObject = [NSEntityDescription insertNewObjectForEntityForName:_coreDataId inManagedObjectContext:self.privateContext];
            [self updateObject:coreDataObject csv:csv];
        }
        else if ([incrementValue isEqualToString:@"U"])
        {
            coreDataObject = [self findObject:csv];
            if (coreDataObject)
                [self updateObject:coreDataObject csv:csv];
        }
        else if ([incrementValue isEqualToString:@"D"])
        {
            coreDataObject = [self findObject:csv];
            [self.privateContext deleteObject:coreDataObject];
        }
        
    }
    
    NSError* error = nil;
    [self.privateContext save:&error];
        
    return error? NO:YES;
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
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    
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

- (NSManagedObject*) findObject:(NSArray *)csv
{
    return nil;
}

- (void) updateObject:(NSManagedObject *)obj csv:(NSArray *)csv
{
    
}


@end
