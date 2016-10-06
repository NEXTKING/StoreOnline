//
//  ImageViewerController.m
//  Checklines
//
//  Created by Denis Kurochkin on 27.01.15.
//  Copyright (c) 2015 Denis Kurochkin. All rights reserved.
//

#import "ImageViewerController.h"

@interface ImageViewerController ()

@end

@implementation ImageViewerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
  
}
@end
