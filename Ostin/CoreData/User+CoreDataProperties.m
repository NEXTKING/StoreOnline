//
//  User+CoreDataProperties.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 28/10/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic key_user;
@dynamic barcode;
@dynamic login;
@dynamic password;
@dynamic name;

@end
