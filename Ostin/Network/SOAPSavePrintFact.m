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
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
//    binding.logXMLInOut = NO;
//    binding.timeout = 300;
//    
//    PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *request = [PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput new];
//    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
//    request.A_MESSAGEVARCHAR2OUT = [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 new];
//    request.AT_PRINT_INFOPASTINGBILLPRINTINFOCIN = [PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType new];
//    request.AT_PRINT_INFOPASTINGBILLPRINTINFOCIN.PASTINGBILLPRINTINFO = [PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO new];
//    
//    NSMutableArray *printWareInfos = [[NSMutableArray alloc] init];
//    for (NSString *wareCode in self.wareCodes)
//    {
//        PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType *printWareInfo = [PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType new];
//        printWareInfo.TASK_NUM = self.taskName;
//        printWareInfo.WARE_CODE = wareCode;
//        printWareInfo.TASK_TYPE = self.taskType;
//        printWareInfo.IS_LABEL_PRINTED = @"Y";
//        printWareInfo.EXECUTED_USER = self.userID;
//        [printWareInfos addObject:printWareInfo];
//    }
//    request.AT_PRINT_INFOPASTINGBILLPRINTINFOCIN.PASTINGBILLPRINTINFO.WARE_INFO = printWareInfos;
//    
//    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
//    
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding PASTING_SAVE_PRINT_FACTUsingSNUMBER_PASTING_SAVE_PRINT_FACTInput:request];
//    
//    if (!response.error && response.bodyParts.count > 0)
//    {
//        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput class]])
//        {
//            PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput *output = response.bodyParts[0];
//            self.success = output.RETURN.integerValue == 1;
//            self.errorMessage = output.A_MESSAGE;
//        }
//        else
//        {
//            self.success = NO;
//            self.errorMessage = @"Неверный ответ со стороны сервера при передаче напечатанных ценников товаров";
//        }
//    }
//    else
//    {
//        self.success = NO;
//        self.errorMessage = @"Неверный ответ со стороны сервера при передаче напечатанных ценников товаров";
//    }
    
    NSMutableArray *printWareInfos = [[NSMutableArray alloc] init];
    for (NSString *wareCode in self.wareCodes)
    {
        NSDictionary *printWareInfo = @{@"00PASTINGBILLPRINTWAREINFO":@{@"00TASK_NUM":self.taskName,
                                                                        @"01TASK_TYPE":self.taskType,
                                                                        @"02WARE_CODE":wareCode,
                                                                        @"03IS_LABEL_PRINTED": @"Y",
                                                                        @"04EXECUTED_USER": self.userID}};
        [printWareInfos addObject:printWareInfo];
    }
    
    NSDictionary *params = @{@"00A_MESSAGE-VARCHAR2-OUT":[NSNull null],
                             @"01A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"02AT_PRINT_INFO-PASTINGBILLPRINTINFO-CIN":@{@"00PASTINGBILLPRINTINFO":@{@"00WARE_INFO":printWareInfos}}};
    
    SOAPRequest *request = [[SOAPRequest alloc] init];
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"PASTING_SAVE_PRINT_FACT" prefix:@"SNUMBER-" params:params authValue:self.authValue];
    
    if (!response.error)
    {
        NSString *RETURN = [response valueForParam:@"RETURN"];
        NSString *message = [response valueForParam:@"A_MESSAGE"];
        
        if (RETURN)
        {
            self.success = RETURN.integerValue == 1;
            self.errorMessage = message;
        }
        else
        {
            self.success = NO;
            self.errorMessage = @"Неверный ответ со стороны сервера при передаче напечатанных ценников товаров";
        }
    }
    else
    {
        self.success = NO;
        self.errorMessage = @"Неверный ответ со стороны сервера при передаче напечатанных ценников товаров";
    }
}

@end
