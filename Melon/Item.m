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

- (void) setAdditionalParameters:(NSDictionary*)params
{
    NSMutableSet *paramsDBSet = [NSMutableSet new];
    
    NSArray *keys = [params allKeys];
    for (NSString *key in keys)
    {
        id value = @"";
        if ([params[key] isKindOfClass:[NSString class]])
            value = params[key];
        
        AdditionalParameter *parameterDB = [NSEntityDescription insertNewObjectForEntityForName:@"AdditionalParameter" inManagedObjectContext:[self managedObjectContext]];
        [parameterDB setValue:key forKey:@"name"];
        [parameterDB setValue:value forKey:@"value"];
        
        [paramsDBSet addObject:parameterDB];
    }
    
    [self addAdditionalParams:paramsDBSet];

}
// Insert code here to add functionality to your managed object subclass

@end
