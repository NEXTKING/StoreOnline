//
//  SOAPSavePrintFact.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 20/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPSavePrintFact.h"

@implementation SOAPSavePrintFact

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
    
    PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *request = [PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_MESSAGEVARCHAR2OUT = [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 new];
    request.AT_PRINT_INFOPASTINGBILLPRINTINFOCIN = [PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType new];
    request.AT_PRINT_INFOPASTINGBILLPRINTINFOCIN.PASTINGBILLPRINTINFO = [PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO new];
    
    NSMutableArray *printWareInfos = [[NSMutableArray alloc] init];
    for (NSString *wareCode in self.wareCodes)
    {
        PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType *printWareInfo = [PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType new];
        printWareInfo.TASK_NUM = self.taskName;
        printWareInfo.WARE_CODE = wareCode;
        printWareInfo.TASK_TYPE = self.taskType;
        printWareInfo.IS_LABEL_PRINTED = @"Y";
        printWareInfo.EXECUTED_USER = self.userID;
        [printWareInfos addObject:printWareInfo];
    }
    request.AT_PRINT_INFOPASTINGBILLPRINTINFOCIN.PASTINGBILLPRINTINFO.WARE_INFO = printWareInfos;
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding PASTING_SAVE_PRINT_FACTUsingSNUMBER_PASTING_SAVE_PRINT_FACTInput:request];
    
    if (!response.error && response.bodyParts.count > 0)
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput class]])
        {
            PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput *output = response.bodyParts[0];
            self.success = output.RETURN.integerValue == 1;
            self.errorMessage = output.A_MESSAGE;
        }
        else
        {
            self.success = NO;
            self.errorMessage = @"Неверный ответ со стороны сервера при передаче напечатанных товаров";
        }
    }
    else
    {
        self.success = NO;
        self.errorMessage = @"Неверный ответ со стороны сервера при передаче напечатанных товаров";
    }
}

@end
