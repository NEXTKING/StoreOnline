//
//  Task+CoreDataProperties.h
//  
//
//  Created by Denis Kurochkin on 10/10/2016.
//
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *taskID;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSNumber *totalPrintedCount;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSDate *endDate;
@end

NS_ASSUME_NONNULL_END
