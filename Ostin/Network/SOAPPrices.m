//
//  SOAPPrices.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 09/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPPrices.h"
#import "Price+CoreDataClass.h"

@implementation SOAPPrices

- (void) main
{
    
    self.incValue = @"ware_price";
    [super main];
    
}

- (NSArray*) downloadItems
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = NO;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 new];
    
    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
    
    
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding WARE_PRICE_INFOUsingWARE_PRICE_INFOInput:request];
    
    if (!response.error && response.bodyParts.count > 0 )
        
    {
        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput class]])
        {
            PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput *output = response.bodyParts[0];
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
        
        Price *priceDB = [NSEntityDescription insertNewObjectForEntityForName:@"Price" inManagedObjectContext:self.privateContext];
        
        priceDB.itemID          = @([csv[1] integerValue]);
        priceDB.catalogPrice    = @([csv[2] doubleValue]);
        priceDB.retailPrice     = @([csv[3] doubleValue]);
        priceDB.discount        = @([csv[4] doubleValue]);
    }
    
    NSError* error = nil;
    [self.privateContext save:&error];
    
    return error? NO:YES;
}

@end
