//
//  SOAPTasks.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 10/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPTasks.h"
#import "Task+CoreDataClass.h"

@implementation SOAPTasks

- (void) main
{
    self.incValue = @"pasting_task";
    self.coreDataId = @"Task";
    [super main];
}

- (NSArray*) downloadItems
{
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
//    binding.logXMLInOut = YES;
//    binding.timeout = 300;
//    
//    PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput* request = [PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput new];
//    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
//    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 new];
//    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 new];
//    
//    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
//    
//    
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding PASTING_TASK_INFOUsingPASTING_TASK_INFOInput:request];
//    
//    if (!response.error && response.bodyParts.count > 0 )
//        
//    {
//        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput class]])
//        {
//            PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput *output = response.bodyParts[0];
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
    
    NSDictionary *params = @{@"A_ID_PORTION-NUMBER-OUT":[NSNull null],
                             @"A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"AO_DATA-TROWARRAY-COUT":[NSNull null]};
    SOAPRequest *request = [[SOAPRequest alloc] init];
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"PASTING_TASK_INFO" prefix:nil params:params authValue:self.authValue];
    
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
    Task* taskDB = (Task*)obj;
    
    taskDB.taskID = @([csv[1] integerValue]);
    taskDB.name = csv[2];
    taskDB.userID = csv[3];
    if (csv.count >= 4)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy hh:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:csv[4]];
        taskDB.dateCreated = date;
    }
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSInteger taskID = [csv[1] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"taskID == %@", @(taskID)]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}

@end
