//
//  Item+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 9/2/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

@dynamic name;
@dynamic article;
@dynamic barcode;
@dynamic itemId;
@dynamic price;
@dynamic additionalParams;
@dynamic stock;

@end
