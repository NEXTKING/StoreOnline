//
//  MCPOfflineInmpl.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCProtocol.h"
#import "CoreDataController.h"

@interface MCPOfflineInmpl : NSObject <MCProtocol>

@property (nonatomic, copy) NSString* serverAddress;
@property (nonatomic, strong) CoreDataController* dataController;

@end
