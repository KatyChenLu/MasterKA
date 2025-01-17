//
//  LaunchScreenViewController.m
//  MasterKA
//
//  Created by jinghao on 15/12/23.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()
@property (nonatomic, strong) UIView *snapshotView;
@property (nonatomic, readonly) NSString *launchScreenName;
@property (nonatomic, readonly) BOOL isStatusBarInitiallyHidden;

@end

@implementation LaunchScreenViewController

- (UIView *)snapshotView
{
    if (_snapshotView == nil) {
        UIView *viewCopy = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.view]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:viewCopy];
        viewCopy.frame = window.bounds;
        
        UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0.0);
        [viewCopy.layer renderInContext:UIGraphicsGetCurrentContext()];
        [viewCopy removeFromSuperview];
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _snapshotView = [[UIImageView alloc] initWithImage:img];
        _snapshotView.frame = [UIScreen mainScreen].bounds;
    }
    return _snapshotView;
}

- (NSString *)launchScreenName
{
    return [[NSBundle mainBundle] infoDictionary][@"UILaunchStoryboardName"];
}

- (BOOL)isStatusBarInitiallyHidden
{
    return [[[NSBundle mainBundle] infoDictionary][@"UIStatusBarHidden"] boolValue];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarInitiallyHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *app = [UIApplication sharedApplication];
    self.view = [[UINib nibWithNibName:self.launchScreenName bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    self.view.frame = app.keyWindow.bounds;
    [self.view layoutIfNeeded];
    if (self.isStatusBarInitiallyHidden)
        app.keyWindow.windowLevel = UIWindowLevelStatusBar+1;
    [app.keyWindow addSubview:self.snapshotView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.snapshotView removeFromSuperview];
    UIApplication *app = [UIApplication sharedApplication];
    if (self.isStatusBarInitiallyHidden)
        app.keyWindow.windowLevel = UIWindowLevelNormal;
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
