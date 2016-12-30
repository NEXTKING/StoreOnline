//
//  SOAPClaim.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 26/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPClaim.h"
#import "Claim+CoreDataClass.h"

@implementation SOAPClaim

- (void) main
{
    self.incValue = @"claim";
    self.coreDataId = @"Claim";
    [super main];
    
}

- (NSArray*) downloadItems
{
    NSDictionary *params = @{@"A_ID_PORTION-NUMBER-OUT":[NSNull null],
                             @"A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"AO_DATA-TROWARRAY-COUT":[NSNull null]};
    SOAPRequest *request = [[SOAPRequest alloc] init];
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"CLAIM_INFO" prefix:nil params:params authValue:self.authValue];
    
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
    Claim* claimDB = (Claim*)obj;
    
    claimDB.claimID = @([csv[1] integerValue]);
    claimDB.claimNumber  = csv[2];
    claimDB.userID    = @([csv[3] integerValue]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd.MM.yyyy HH:mm:ss";
    claimDB.incomingDate = [dateFormatter dateFromString:csv[4]];
    
    claimDB.startDate = nil;
    claimDB.endDate = nil;
}

- (NSManagedObject*) findObject:(NSArray *)csv
{
    NSNumber *claimID = @([csv[1] integerValue]);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Claim"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"claimID == %@", claimID]];
    
    NSError* error = nil;
    NSArray* results = [self.privateContext executeFetchRequest:request error:&error];
    
    if (results.count > 0)
        return results[0];
    return nil;
}

@end
