//
//  XMLLoyaltyParser.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 18.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLLoyaltyParser : NSXMLParser

@property (nonatomic, strong, readonly) NSArray* loyaltyArray;

@end
