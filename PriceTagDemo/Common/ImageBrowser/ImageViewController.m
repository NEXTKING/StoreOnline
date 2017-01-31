//
//  ImageViewController.m
//  PartitionTest
//
//  Created by Denis Kurochkin on 27/01/2017.
//  Copyright © 2017 Denis Kurochkin. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    imageView.frame = self.view.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionPrivate)];
    [imageView addGestureRecognizer:tapGesture];
    //self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}

- (void) tapActionPrivate
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    _tapAction();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
