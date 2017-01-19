//
//  SOAPClaim.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 26/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPClaim.h"
#import "Claim+CoreDataClass.h"

@import UIKit;
@import UserNotifications;

@implementation SOAPClaim

- (void) main
{
    self.incValue = @"claim";
    self.coreDataId = @"Claim";
    [super main];
    
}

- (NSArray*) downloadItems
{
    NSDictionary *params = @{@"00A_ID_PORTION-NUMBER-OUT":[NSNull null],
                             @"01A_DEVICE_UID-VARCHAR2-IN":self.deviceID,
                             @"02AO_DATA-TROWARRAY-COUT":[NSNull null]};
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
    
    if ([csv[0] isEqualToString:@"I"])
    {
        claimDB.startDate = nil;
        claimDB.endDate = nil;
        
        if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground)
            [self notifity:csv[2]];
    }
    else if ([csv[0] isEqualToString:@"D"])
    {
        [self cancelNotifity:csv[2]];
    }
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

- (void)notifity:(NSString *)claimNumber
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        __weak typeof(center) _center = center;
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
            {
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.title = @"Новая заявка";
                content.body = [NSString stringWithFormat:@"Заявка %@ поступила в интернет магазин", claimNumber];
                content.sound = [UNNotificationSound defaultSound];
                
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.f repeats:NO];
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:claimNumber content:content trigger:trigger];
                
                [_center addNotificationRequest:request withCompletionHandler:^(NSError *error){}];
            }
        }];
    }
}

- (void)cancelNotifity:(NSString *)claimNumber
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        __weak typeof(center) _center = center;
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized)
            {
                [_center removePendingNotificationRequestsWithIdentifiers:@[claimNumber]];
                [_center removeDeliveredNotificationsWithIdentifiers:@[claimNumber]];
            }
        }];
    }
}

@end
