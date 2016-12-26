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
    self.coreDataId = @"Price";
    [super main];
    
}

- (NSArray*) downloadItems
{
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
//    binding.logXMLInOut = NO;
//    binding.timeout = 300;
//    
//    PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput new];
//    request.A_DEVICE_UIDVARCHAR2IN = self.deviceID;
//    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 new];
//    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 new];
//    
//    [binding.customHeaders setObject:self.authValue forKey:@"Authorization"];
//    
//    
//    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response = [binding WARE_PRICE_INFOUsingWARE_PRICE_INFOInput:request];
//    
//    if (!response.error && response.bodyParts.count > 0 )
//        
//    {
//        if ([response.bodyParts[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput class]])
//        {
//            PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput *output = response.bodyParts[0];
//            PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
//            
//            currentPortionID = [output.A_ID_PORTION integerValue];
//            return data.TROWARRAY.CSV_ROWS;
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
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"WARE_PRICE_INFO" prefix:nil params:params authValue:self.authValue];
    
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
    Price* priceDB = (Price*)obj;
    
    if (csv.count >= 5)
    {
        priceDB.itemID          = @([csv[1] integerValue]);
        priceDB.catalogPrice    = @([csv[2] doubleValue]);
        priceDB.retailPrice     = @([csv[3] doubleValue]);
        priceDB.discount        = @([csv[4] doubleValue]);
        
        if (csv.count >= 9)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy hh:mm:ss"];
            NSDate *date = [dateFormatter dateFromString:csv[8]];
            priceDB.dateModified = date;
        }
    }
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSInteger itemID = [csv[1] integerValue];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", @(itemID)]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}

@end
