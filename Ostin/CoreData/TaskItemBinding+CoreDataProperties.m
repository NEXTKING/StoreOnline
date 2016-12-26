//
//  TaskItemBinding+CoreDataProperties.m
//  
//
//  Created by Denis Kurochkin on 10/10/2016.
//
//

#import "TaskItemBinding+CoreDataProperties.h"

@implementation TaskItemBinding (CoreDataProperties)

+ (NSFetchRequest<TaskItemBinding *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TaskItemBinding"];
}

@dynamic bindingKey;
@dynamic taskID;
@dynamic quantity;
@dynamic itemID;
@dynamic scanned;

@end
