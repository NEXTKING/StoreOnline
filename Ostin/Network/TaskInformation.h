//
//  TaskInformation.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 10/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "SOAPOperation.h"

@interface TaskInformation : NSObject

@property (nonatomic, assign) NSInteger taskID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger status;


@end
