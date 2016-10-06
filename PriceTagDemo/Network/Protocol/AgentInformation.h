//
//  AgentInformation.h
//  Checklines
//
//  Created by Denis Kurochkin on 11/21/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentInformation : NSObject

@property (nonatomic, assign) NSInteger agentId;
@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, assign) NSInteger experience;
@property (nonatomic, assign) NSInteger earnAmount;
@property (nonatomic, assign) NSInteger points;

@end
