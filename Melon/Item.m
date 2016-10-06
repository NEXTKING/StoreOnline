//
//  Item.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 9/2/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "Item.h"
#import "AdditionalParameter.h"

@implementation Item

- (void) setAdditionalParameters:(NSArray<ParameterInformation *> *)params
{
    NSMutableSet *paramsDBSet = [NSMutableSet new];
    
    for (ParameterInformation* paramInfo in params)
    {
        AdditionalParameter *parameterDB = [NSEntityDescription insertNewObjectForEntityForName:@"AdditionalParameter" inManagedObjectContext:[self managedObjectContext]];
        [parameterDB setValue:paramInfo.name forKey:@"name"];
        [parameterDB setValue:paramInfo.value forKey:@"value"];
        
        [paramsDBSet addObject:parameterDB];
    }
    
    [self addAdditionalParams:paramsDBSet];

}
// Insert code here to add functionality to your managed object subclass

@end
