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
    _incValue = @"pasting_task";
    [super main];
}

- (NSArray*) downloadItems
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = YES;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput* request = [PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 new];
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding PASTING_TASK_INFOUsingPASTING_TASK_INFOInput:request];
    
    if (!response.error && response.bodyParts.count > 0 )
        
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput class]])
        {
            PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput *output = response.bodyParts[0];
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
        
        Task *taskDB = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.dataController.managedObjectContext];
        
        taskDB.taskID          = @([csv[1] integerValue]);
        taskDB.name            = csv[2];
        taskDB.userID          = @([csv[3] integerValue]);
    }
    
    NSError* error = nil;
    [self.dataController.managedObjectContext save:&error];
    
    return error? NO:YES;
}


@end
