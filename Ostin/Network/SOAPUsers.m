//
//  SOAPUsers.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 28/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPUsers.h"
#import "User+CoreDataClass.h"

@implementation SOAPUsers

- (void) main
{
    _incValue = @"user";
    [super main];
    
}

- (NSArray*) downloadItems
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = NO;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementUSER_INFOInput* request = [PI_MOBILE_SERVICEService_ElementUSER_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 new];
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];

    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding USER_INFOUsingUSER_INFOInput:request];
    
    if (!response.error && response.bodyParts.count > 0 )
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementUSER_INFOOutput class]])
        {
            PI_MOBILE_SERVICEService_ElementUSER_INFOOutput *output = response.bodyParts[0];
            PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
            
            currentPortionID = [output.A_ID_PORTION integerValue];
            return data.TROWARRAY.CSV_ROWS;
        }
    }
    else
        return nil;
    
    return nil;
}

- (BOOL) saveItems: (NSArray*) items
{
    for (PI_MOBILE_SERVICEService_TROW_IntType *throw in items)
    {
        NSArray *csvSourse = [throw.VAL componentsSeparatedByString:@";"];
        NSArray *csv       = [self removeQuotes:csvSourse];
        
        User *userDB = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.privateContext];
        
        userDB.key_user = csv[1];
        userDB.barcode  = csv[2];
        userDB.login    = csv[3];
        userDB.password = csv[4];
        userDB.name     = csv[5];
    }
    
    NSError* error = nil;
    [self.privateContext save:&error];
    
    return error? NO:YES;
}

@end
