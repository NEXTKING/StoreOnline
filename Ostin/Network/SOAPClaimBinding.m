//
//  SOAPClaimBinding.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 26/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPClaimBinding.h"
#import "ClaimBinding+CoreDataClass.h"

@implementation SOAPClaimBinding

- (void) main
{
    self.incValue = @"claim_str";
    self.coreDataId = @"ClaimBinding";
    [super main];
    
}

- (NSArray*) downloadItems
{
    NSDictionary *params = @{@"A_ID_PORTION-NUMBER-OUT":[NSNull null],
                             @"A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"AO_DATA-TROWARRAY-COUT":[NSNull null]};
    SOAPRequest *request = [[SOAPRequest alloc] init];
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"CLAIM_STR_INFO" prefix:nil params:params authValue:self.authValue];
    
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
    ClaimBinding* claimBindingDB = (ClaimBinding*)obj;
    
    claimBindingDB.claimBindingID = @([csv[1] integerValue]);
    claimBindingDB.claimID = @([csv[2] integerValue]);
    claimBindingDB.itemID = @([csv[3] integerValue]);
    claimBindingDB.quantity = @([csv[4] integerValue]);
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSNumber *claimBindingID = @([csv[1] integerValue]);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ClaimBinding"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"claimBindingID == %@", claimBindingID]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}

@end
