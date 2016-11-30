//
//  Task+CoreDataProperties.m
//  
//
//  Created by Denis Kurochkin on 10/10/2016.
//
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Task"];
}

@dynamic dateCreated;
@dynamic taskID;
@dynamic name;
@dynamic userID;
@dynamic totalPrintedCount;
@dynamic startDate;
@dynamic endDate;

@end
