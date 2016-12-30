//
//  SOAPProcessClaim.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 28/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPProcessClaim.h"
#import "ClaimItemInformation.h"

@implementation SOAPProcessClaim

- (void)main
{
    if (self.isCancelled)
        return;
    
    [self commitOperation];
}

- (void)commitOperation
{
    NSMutableArray *claimItemInfos = [[NSMutableArray alloc] init];
    for (ClaimItemInformation *claimItem in self.claimItems)
    {
        NSDictionary *claimItemInfo = @{@"00TCLAIMITEM":@{@"00ID_CLAIM_STR":[NSString stringWithFormat:@"%ld", claimItem.claimBindingID.unsignedIntegerValue],
                                                        @"01FOUND_QUANTITY":[NSString stringWithFormat:@"%ld", claimItem.scannedCount],
                                                        @"02ID_CANCEL_REASON":claimItem.cancelReason}};
        [claimItemInfos addObject:claimItemInfo];
    }
    
    NSDictionary *params = @{@"00A_MESSAGE-VARCHAR2-OUT":[NSNull null],
                             @"01A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"02A_USER_LOGIN-VARCHAR2-IN":self.userID,
                             @"03AO_CLAIM-TCLAIM-CIN":@{@"TCLAIM":@{@"00ID_CLAIM":self.claimID,
                                                                  @"01CLAIM_ITEMS":claimItemInfos}}};
    
    SOAPRequest *request = [[SOAPRequest alloc] init];
    SOAPRequestResponse *response = [request soapRequestWithMethod:@"PROCESS_CLAIM" prefix:@"SNUMBER-" params:params authValue:self.authValue];
    
    if (!response.error)
    {
        NSString *RETURN = [response valueForParam:@"RETURN"];
        NSString *message = [response valueForParam:@"A_MESSAGE"];
        
        if (RETURN)
        {
            self.success = RETURN.integerValue == 1;
            self.errorMessage = message;
        }
        else
        {
            self.success = NO;
            self.errorMessage = @"Неверный ответ со стороны сервера при завершении заявки";
        }
    }
    else
    {
        self.success = NO;
        self.errorMessage = @"Неверный ответ со стороны сервера при завершении заявки";
    }
}

@end
