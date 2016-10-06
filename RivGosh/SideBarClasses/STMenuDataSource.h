//
//  STMenuDataSource.h
//  dphHermes
//
//  Created by Denis Kurochkin on 05.11.15.
//
//

#import <UIKit/UIKit.h>

@interface STMenuDataSource : NSObject

@property (nonatomic, strong, readonly) NSArray* cells;
@property (nonatomic, strong, readonly) UIView* headerView;

@end
