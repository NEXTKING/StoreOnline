//
//  AzbukaViewController.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 03.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "AzbukaViewController.h"

@interface AzbukaViewController ()

@end

@implementation AzbukaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self barcodeData:@"2180146" type:0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startLoadingImage:(NSString*) imageName
{
    if (imageName.length > 0)
    {
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            /* Fetch the image from the server... */
            
            NSString *urlPath = @"http://185.36.157.150:7757/storeService/Service1.svc/json/Photo?id=";
            NSString *fullAddress = [NSString stringWithFormat:@"%@%@", urlPath, imageName];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullAddress]];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            
            
            //NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //NSData *data = [result objectForKey:@"photo"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                
                [self imageLoaded:img];
                
            });
        });
    }
}

- (void) imageLoaded:(UIImage *)image
{
    _itemImageView.image = image;
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
