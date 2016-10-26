//
//  SOAPSetTaskDone.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 18/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPOperation.h"

@interface SOAPSetTaskDone : NSOperation

@property (nonatomic, copy) NSString* taskName;
@property (nonatomic, copy) NSString* taskType;
@property (nonatomic, copy) NSString* authValue;
@property (nonatomic, copy) NSString* deviceID;
@property (nonatomic, copy) NSString* userID;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString* errorMessage;

@end
