//
//  ImageViewController.h
//  PartitionTest
//
//  Created by Denis Kurochkin on 27/01/2017.
//  Copyright © 2017 Denis Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (copy, nonatomic) UIImage* image;
@property (copy, nonatomic) void (^tapAction)(void);
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
