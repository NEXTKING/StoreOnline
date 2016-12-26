//
//  SOAPTaskWareBinding.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 14/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPTaskWareBinding.h"
#import "TaskItemBinding+CoreDataClass.h"

@implementation SOAPTaskWareBinding

- (void) main
{
    self.incValue = @"pasting_wares";
    self.coreDataId = @"TaskItemBinding";
    [super main];
}

- (NSArray*) downloadItems
{
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
//    binding.logXMLInOut = YES;
//    binding.timeout = 300;
//    
//    PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput* request = [PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput new];
//    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
//    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 new];
//    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 new];
//    
//    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
//    
//    
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding PASTING_WARES_INFOUsingPASTING_WARES_INFOInput:request];
//    
//    if (!response.error && response.bodyParts.count > 0 )
//        
//    {
//        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput class]])
//        {
//            PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput *output = response.bodyParts[0];
//            PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
//            
//            currentPortionID = [output.A_ID_PORTION integerValue];
//            return data.TROWARRAY.CSV_ROWS;
//            
//            
//        }
//    }
//    else
//        return nil;
    
    NSDictionary *params = @{@"00A_ID_PORTION-NUMBER-OUT":[NSNull null],
                             @"01A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"02AO_DATA-TROWARRAY-COUT":[NSNull null]};
    SOAPRequest *request = [[SOAPRequest alloc] init];
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"PASTING_WARES_INFO" prefix:nil params:params authValue:self.authValue];
    
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
    TaskItemBinding* taskDB = (TaskItemBinding*)obj;
    
    if (csv.count >= 5)
    {
        taskDB.bindingKey = @([csv[1] integerValue]);
        taskDB.taskID = @([csv[2] integerValue]);
        taskDB.itemID = @([csv[3] integerValue]);
        taskDB.quantity = @([csv[4] integerValue]);
    }
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSInteger bindingKey = [csv[1] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TaskItemBinding"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"bindingKey == %@", @(bindingKey)]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}

@end
