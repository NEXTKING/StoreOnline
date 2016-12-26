//
//  SOAPWares.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 08/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPWares.h"
#import "Item+CoreDataClass.h"

@interface SOAPWares ()


@end

@implementation SOAPWares

- (void) main
{
    
    self.incValue   = @"ware";
    self.coreDataId = @"Item";
    [super main];
    
}

- (NSArray*) downloadItems
{
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
//    binding.logXMLInOut = NO;
//    binding.timeout = 300;
//    
//    PI_MOBILE_SERVICEService_ElementWARE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_INFOInput new];
//    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
//    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 new];
//    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 new];
//    
//    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
//    
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding WARE_INFOUsingWARE_INFOInput:request];
//   
//    if (response.bodyParts.count > 0 && !response.error)
//    {
//         if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_INFOOutput class]])
//         {
//             PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *output = response.bodyParts[0];
//             PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
//             
//             currentPortionID = [output.A_ID_PORTION integerValue];
//             return data.TROWARRAY.CSV_ROWS;
//         }
//    }
//     else
//     {
//         return nil;
//     };
    
    NSDictionary *params = @{@"00A_ID_PORTION-NUMBER-OUT":[NSNull null],
                             @"01A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"02AO_DATA-TROWARRAY-COUT":[NSNull null]};
    SOAPRequest *request = [[SOAPRequest alloc] init];
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"WARE_INFO" prefix:nil params:params authValue:self.authValue];

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
    Item* itemDB = (Item*)obj;
    
    itemDB.itemID       = @([csv[1] integerValue]);
    itemDB.itemCode     = (csv.count >= 3) ? csv[2] : nil;
    itemDB.groupID      = (csv.count >= 4) ? @([csv[3] intValue]) : 0;
    itemDB.subgroupID   = (csv.count >= 5) ? @([csv[4] intValue]) : 0;
    itemDB.trademarkID  = (csv.count >= 6) ? @([csv[5] intValue]) : 0;
    itemDB.color        = (csv.count >= 7) ? csv[6] : nil;
    itemDB.certificationType = (csv.count >= 8) ? csv[7] : nil;
    itemDB.certificationAuthorittyCode = (csv.count >= 9) ? csv[8] : nil;
    itemDB.line1        = (csv.count >= 10) ? csv[9] : nil;
    itemDB.line2        = (csv.count >= 11) ? csv[10] : nil;
    itemDB.storeNumber  = (csv.count >= 12) ? csv[11] : nil;
    itemDB.name         = (csv.count >= 13) ? csv[12] : nil;
    itemDB.priceHeader  = (csv.count >= 14) ? csv[13] : nil;
    itemDB.sizeHeader   = (csv.count >= 15) ? csv[14] : nil;
    itemDB.size         = (csv.count >= 16) ? csv[15] : nil;
    itemDB.additionalSize = (csv.count >= 17) ? csv[16] : nil;
    itemDB.additionalInfo = (csv.count >= 18) ? csv[17] : nil;
    itemDB.boxType = (csv.count >= 19) ? csv[18] : nil;
    itemDB.itemCode_2 = (csv.count >= 20) ? csv[19] : nil;
    itemDB.drop = (csv.count >= 21) ? csv[20] : nil;
    itemDB.collection = (csv.count >= 22) ? csv[21] : nil;
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSInteger itemID = [csv[1] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", @(itemID)]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}


@end
