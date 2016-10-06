//
//  CategoriesViewController.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 20/09/16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CollectionLevel
{
    CLGroups = 0,
    CLSubgroups = 1,
    CLSex = 2,
    CLBrands = 3,
    CLModels = 4
    
}CollectionLevel;

@interface CategoriesViewController : UICollectionViewController

- (instancetype) initWithHierarchyLevel:(CollectionLevel) level;

@end
