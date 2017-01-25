//
//  NwpsobjItemDescription.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 25/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCProtocol.h"
#import "NwRequest.h"
#import "NwobjItemDescription.h"

@interface NwpsobjItemDescription : NSObject <INwObject>

@property (nonatomic, weak) id <ItemDescriptionDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* barcode;
@property (nonatomic, copy) NSString* shopId;

// result parameters:
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@property (copy, nonatomic) void (^completionHandler)(NSArray<ItemInformation*>*);

@end
