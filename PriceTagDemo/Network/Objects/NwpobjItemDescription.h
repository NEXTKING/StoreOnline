//
//  NwpobjItemDescription.h
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 23/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCProtocol.h"
#import "NwRequest.h"

@interface NwpobjItemDescription : NSObject

@property (nonatomic, weak) id <ItemDescriptionDelegate> delegate;

// input parameters:

@property (nonatomic, copy) NSString* barcode;
@property (nonatomic, copy) NSString* shopId;

// result parameters:
@property (nonatomic, copy) NSError* error;
@property (readonly, nonatomic, strong) NSProgress *progress;
@property (readonly, getter = isSucceeded, assign) BOOL succeeded;
@property (readonly, assign) int resultCode;

@property (copy, nonatomic) void (^completionHandler)(NSArray<ItemInformation*>*);

@end
