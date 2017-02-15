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
    
    if (csv.count >= 22)
    {
        itemDB.itemID       = @([csv[1] integerValue]);
        itemDB.itemCode     = csv[2];
        itemDB.groupID      = @([csv[3] intValue]);
        itemDB.subgroupID   = @([csv[4] intValue]);
        itemDB.trademarkID  = @([csv[5] intValue]);
        itemDB.color        = csv[6];
        itemDB.certificationType    = csv[7];
        itemDB.certificationAuthorittyCode  = csv[8];
        itemDB.line1        = csv[9];
        itemDB.line2        = csv[10];
        itemDB.storeNumber  = csv[11];
        itemDB.name         = csv[12];
        itemDB.priceHeader  = csv[13];
        itemDB.sizeHeader   = csv[14];
        itemDB.size         = csv[15];
        itemDB.additionalSize = csv[16];
        itemDB.additionalInfo = csv[17];
        itemDB.boxType = csv[18];
        itemDB.itemCode_2 = csv[19];
        itemDB.drop = csv[20];
        itemDB.collection = csv[21];
    }
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
