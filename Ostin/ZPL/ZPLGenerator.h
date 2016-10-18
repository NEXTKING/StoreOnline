//
//  ZPLGenerator.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 18/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemInformation.h"

@interface ZPLGenerator : NSObject

+ (void) generateZPLWithItem:(ItemInformation*) item;

@end
