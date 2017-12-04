//
//  ViewController.m
//  MasterKA
//
//  Created by jinghao on 15/12/7.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (nonatomic,weak)IBOutlet UIImageView* imageView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self shareContentOfApp:nil content:nil imageUrl:nil shareToPlatform:nil];
//        UIViewController *vct = [UIViewController viewControllerDefaultStoryboardWithIdentifier:@"ViewController"];
//        [self.navigationController pushViewController:vct animated:TRUE];
    }];
    int x = arc4random() % 255;
    self.imageView.backgroundColor = [UIColor colorWithRed:x/255.0f green:x/255.0f blue:x/255.0f alpha:1.0];
    int y = arc4random() % 255;
    self.view.backgroundColor = [UIColor colorWithRed:y/255.0f green:y/255.0f blue:y/255.0f alpha:1.0];\
    
    self.title = [NSString stringWithFormat:@"title %ld == %ld",(long)x,(long)y];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
