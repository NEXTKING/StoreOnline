//
//  PrintServer.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 03/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInformation.h"

@interface PrintServer : NSObject

+ (instancetype)instance;
- (void)addItemToPrintQueue:(ItemInformation *)item printFormat:(id)format;

@end
