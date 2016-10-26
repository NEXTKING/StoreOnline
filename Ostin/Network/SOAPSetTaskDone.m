//
//  SOAPSetTaskDone.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 18/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPSetTaskDone.h"

@implementation SOAPSetTaskDone

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
    
    PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *request = [PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_TASK_NUMVARCHAR2IN = self.taskName;
    request.A_MESSAGEVARCHAR2OUT = [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT new];
    request.A_TASK_TYPEVARCHAR2IN = self.taskType;
    request.A_EXECUTED_USERVARCHAR2IN = self.userID;
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding PASTING_SET_TASK_DONEUsingSNUMBER_PASTING_SET_TASK_DONEInput:request];
    
    if (!response.error && response.bodyParts.count > 0)
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput class]])
        {
            PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput *output = response.bodyParts[0];
            self.success = output.RETURN.integerValue == 1;
            self.errorMessage = output.A_MESSAGE;
        }
        else
        {
            self.success = NO;
            self.errorMessage = @"Неверный ответ со стороны сервера при передаче статуса выполнения задания";
        }
    }
    else
    {
        self.success = NO;
        self.errorMessage = @"Неверный ответ со стороны сервера при передаче статуса выполнения задания";
    }
}

@end
