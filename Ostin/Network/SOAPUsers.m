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
#if defined (OSTIN_IM)
    self.incValue = @"user_orzim";
#else
    self.incValue = @"user";
#endif
    self.coreDataId = @"User";
    [super main];
    
}

- (NSArray*) downloadItems
{
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
//    binding.logXMLInOut = NO;
//    binding.timeout = 300;
//    
//    PI_MOBILE_SERVICEService_ElementUSER_INFOInput* request = [PI_MOBILE_SERVICEService_ElementUSER_INFOInput new];
//    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
//    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 new];
//    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 new];
//    
//    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
//
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding USER_INFOUsingUSER_INFOInput:request];
//    
//    if (!response.error && response.bodyParts.count > 0 )
//    {
//        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementUSER_INFOOutput class]])
//        {
//            PI_MOBILE_SERVICEService_ElementUSER_INFOOutput *output = response.bodyParts[0];
//            PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
//            
//            currentPortionID = [output.A_ID_PORTION integerValue];
//            return data.TROWARRAY.CSV_ROWS;
//        }
//    }
//    else
//        return nil;
    
    NSDictionary *params = @{@"00A_ID_PORTION-NUMBER-OUT":[NSNull null],
                             @"01A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"02AO_DATA-TROWARRAY-COUT":[NSNull null]};
    SOAPRequest *request = [[SOAPRequest alloc] init];
#if defined (OSTIN_IM)
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"USER_ORZIM_INFO" prefix:nil params:params authValue:self.authValue];
#else
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"USER_INFO" prefix:nil params:params authValue:self.authValue];
#endif
    
    if (!response.error)
    {
        NSString *portionID = [response valueForParam:@"A_ID_PORTION"];
        NSArray *csvRows = [response valuesForParam:@"VAL"];
        
        if (portionID && csvRows)
        {
            currentPortionID = portionID.integerValue;
            return csvRows;
        }
        else
            return nil;
    }
    else
        return nil;
}

- (void) updateObject:(NSManagedObject *)obj csv:(NSArray *)csv
{
    User* userDB = (User*)obj;
    
    userDB.key_user = csv[1];
    userDB.barcode  = csv[2];
    userDB.login    = csv[3];
    userDB.password = csv[4];
    userDB.name     = csv[5];
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSString *key_user = csv[1];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"key_user == %@", key_user]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}

@end
