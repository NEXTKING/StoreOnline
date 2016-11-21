//
//  TaskItemBinding+CoreDataProperties.h
//  
//
//  Created by Denis Kurochkin on 10/10/2016.
//
//

#import "TaskItemBinding+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskItemBinding (CoreDataProperties)

+ (NSFetchRequest<TaskItemBinding *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *taskID;
@property (nullable, nonatomic, copy) NSNumber *quantity;
@property (nullable, nonatomic, copy) NSNumber *itemID;
@property (nullable, nonatomic, copy) NSNumber *scanned;
@property (nullable, nonatomic, copy) NSNumber *wasUploaded;

@end

NS_ASSUME_NONNULL_END
