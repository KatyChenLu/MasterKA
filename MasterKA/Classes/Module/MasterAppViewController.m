//
//  MasterAppViewController.m
//  MasterKA
//
//  Created by jinghao on 15/12/23.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "MasterAppViewController.h"

@interface MasterAppViewController ()
@property (nonatomic, weak) UIImageView *dynamicImageIVew;

@end

@implementation MasterAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dynamicImageIVew = [self.view viewWithTag:100];
    [self.dynamicImageIVew setImageWithURLString:@"http://img15.3lian.com/2015/f2/147/d/14.jpg" placeholderImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"==== stat app ====");
    self.dynamicImageIVew.hidden = NO;
    self.dynamicImageIVew.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.dynamicImageIVew.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3.0 animations:^{
            self.dynamicImageIVew.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
