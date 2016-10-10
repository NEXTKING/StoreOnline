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
    
    _incValue = @"ware_barcode";
    [super main];
    
}

- (NSArray*) downloadItems
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = YES;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = @"300";
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 new];
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding WARE_BARCODE_INFOUsingWARE_BARCODE_INFOInput:request];
    
    if (!response.error && response.bodyParts.count > 0 )
    
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput class]])
         {
             PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput *output = response.bodyParts[0];
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
     
        Barcode *barcodeDB = [NSEntityDescription insertNewObjectForEntityForName:@"Barcode" inManagedObjectContext:self.dataController.managedObjectContext];
        
        barcodeDB.itemID  = @([csv[1] integerValue]);
        barcodeDB.code128 = csv[2];
        barcodeDB.ean     = csv[3];
        
    }
    
    NSError* error = nil;
    [self.dataController.managedObjectContext save:&error];
    
    return error? NO:YES;
}


@end
