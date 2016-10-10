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
@property (nullable, nonatomic, copy) NSNumber *userID;
@property (nullable, nonatomic, copy) NSNumber *isCompleted;

@end

NS_ASSUME_NONNULL_END
