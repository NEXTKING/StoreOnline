//
//  Barcode+CoreDataProperties.h
//  
//
//  Created by Denis Kurochkin on 07/10/2016.
//
//

#import "Barcode+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Barcode (CoreDataProperties)

+ (NSFetchRequest<Barcode *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *code128;
@property (nullable, nonatomic, copy) NSString *ean;
@property (nullable, nonatomic, copy) NSNumber *itemID;

@end

NS_ASSUME_NONNULL_END
