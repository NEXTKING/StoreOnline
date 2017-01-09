//
//  SOAPBarcodes.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 08/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPBarcodes.h"
#import "Barcode+CoreDataClass.h"

@implementation SOAPBarcodes

- (void) main
{
    
    self.incValue = @"ware_barcode";
    self.coreDataId = @"Barcode";
    [super main];
    
}

- (NSArray*) downloadItems
{
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
//    binding.logXMLInOut = NO;
//    binding.timeout = 300;
//    
//    PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput new];
//    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
//    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 new];
//    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 new];
//    
//    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
//    
//    
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding WARE_BARCODE_INFOUsingWARE_BARCODE_INFOInput:request];
//    
//    if (!response.error && response.bodyParts.count > 0 )
//    
//    {
//        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput class]])
//         {
//             PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput *output = response.bodyParts[0];
//             PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
//             
//             currentPortionID = [output.A_ID_PORTION integerValue];
//             return data.TROWARRAY.CSV_ROWS;
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
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"WARE_BARCODE_INFO" prefix:nil params:params authValue:self.authValue];
    
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

    return nil;
}

- (void) updateObject:(NSManagedObject *)obj csv:(NSArray *)csv
{
    Barcode* barcodeDB = (Barcode*)obj;
    
    barcodeDB.itemID = @([csv[1] integerValue]);
    barcodeDB.code128 = csv[2];
    barcodeDB.ean = csv[3];
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSInteger itemID = [csv[1] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Barcode"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", @(itemID)]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}

@end
