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
    
   _incValue = @"ware";
    [super main];
    
}

- (NSArray*) downloadItems
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = NO;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementWARE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 new];
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding WARE_INFOUsingWARE_INFOInput:request];
   
    if (response.bodyParts.count > 0 && !response.error)
    {
         if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_INFOOutput class]])
         {
             PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *output = response.bodyParts[0];
             PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
             
             currentPortionID = [output.A_ID_PORTION integerValue];
             return data.TROWARRAY.CSV_ROWS;
         }
    }
     else
     {
         return nil;
     };
    
    return nil;

}

- (BOOL) saveItems: (NSArray*) items
{
    
    for (PI_MOBILE_SERVICEService_TROW_IntType *throw in items)
    {
        NSArray *csvSourse = [throw.VAL componentsSeparatedByString:@";"];
        NSArray *csv       = [self removeQuotes:csvSourse];
        Item *itemDB = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.privateContext];
        
        itemDB.itemID       = @([csv[1] integerValue]);
        itemDB.itemCode     = csv[2];
        itemDB.groupID      = @([csv[3] intValue]);
        itemDB.subgroupID   = @([csv[4] intValue]);
        itemDB.trademarkID  = @([csv[5] intValue]);
        itemDB.color        = csv[6];
        itemDB.certificationType    = csv[7];
        itemDB.certificationAuthorittyCode  = csv[8];
        itemDB.itemCode_2   = csv[9];
        itemDB.line1        = csv[9]; // csv[10];
        itemDB.line2        = csv[10]; // csv[11];
        itemDB.storeNumber  = csv[11]; // csv[12];
        itemDB.name         = csv[12]; // csv[13];
        itemDB.priceHeader  = csv[13]; // csv[14];
        itemDB.sizeHeader   = csv[14]; // csv[15];
        itemDB.size         = csv[15]; // csv[16];
        itemDB.additionalSize = csv[16];
        itemDB.additionalInfo = csv[17];
        itemDB.boxType = csv[18];
    }
    
    NSError* error = nil;
    [self.privateContext save:&error];
    
    return error? NO:YES;
}


@end
