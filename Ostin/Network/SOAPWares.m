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
        Item *itemDB = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext];
        
        itemDB.itemID       = @([csv[1] longLongValue]);
        itemDB.itemCode     = csv[1];
        itemDB.groupID      = @([csv[2] intValue]);
        itemDB.subgroupID   = @([csv[3] intValue]);
        itemDB.trademarkID  = @([csv[4] intValue]);
        itemDB.color        = csv[5];
        itemDB.certificationType    = csv[6];
        itemDB.certificationAuthorittyCode  = csv[7];
        itemDB.itemCode_2   = csv[8];
        itemDB.line1        = csv[9];
        itemDB.line2        = csv[10];
        itemDB.storeNumber  = csv[11];
        itemDB.name         = csv[12];
        itemDB.priceHeader  = csv[14];
        itemDB.sizeHeader   = csv[15];
        itemDB.size         = csv[16];
        itemDB.additionalInfo = csv[17];
        //itemDB.additionalInfo = csv[18];
        
    }
    
    NSError* error = nil;
    [self.dataController.managedObjectContext save:&error];
    
    return error? NO:YES;
}


@end
