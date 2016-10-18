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
    _incValue = @"pasting_wares";
    [super main];
}

- (NSArray*) downloadItems
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = YES;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput* request = [PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 new];
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding PASTING_WARES_INFOUsingPASTING_WARES_INFOInput:request];
    
    if (!response.error && response.bodyParts.count > 0 )
        
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput class]])
        {
            PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput *output = response.bodyParts[0];
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
        
        TaskItemBinding *taskDB = [NSEntityDescription insertNewObjectForEntityForName:@"TaskItemBinding" inManagedObjectContext:self.dataController.managedObjectContext];
        
        taskDB.itemID            = @([csv[1] integerValue]);
        taskDB.taskID            = @([csv[2] integerValue]);
        taskDB.quantity          = @([csv[3] integerValue]);
    }
    
    NSError* error = nil;
    [self.dataController.managedObjectContext save:&error];
    
    return error? NO:YES;
}

@end
