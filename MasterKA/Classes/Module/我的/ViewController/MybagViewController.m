//
//  MybagViewController.m
//  MasterKA
//
//  Created by hyu on 16/5/24.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MybagViewController.h"
#import "MyScoreViewController.h"
#import "MyCouponViewController.h"
#import "MyCardViewController.h"
@interface MybagViewController ()<HJHPageViewControllerDelegate,HJHPageViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray *viewControllers;
@end

@implementation MybagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"卡券包";
    self.dataSource = self;
    self.delegate = self;
    
    
    self.segmentedControl.titleTextAttributes =  @{
                                                   NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                                                   NSForegroundColorAttributeName : [UIColor colorWithHex:0x737373],
                                                   };
    self.segmentedControl.selectedTitleTextAttributes =  @{
                                                           NSFontAttributeName : [UIFont systemFontOfSize:13.0f],
                                                           NSForegroundColorAttributeName : [UIColor colorWithHex:0x737373],
                                                           };
    
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0xa52040];
    self.segmentedControl.selectionIndicatorHeight = 1.0f;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -6, 0);
    
    
    [self initHeadViewData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initHeadViewData{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UIViewController *vct1 =  [story instantiateViewControllerWithIdentifier:@"MyCouponViewController"];
    vct1.title = @"代金券";
    UIViewController *vct2 =  [story instantiateViewControllerWithIdentifier:@"MyScoreViewController"];
    vct2.params = @{@"score":self.params[@"score"]};
    vct2.title = @"M点积分";
    UIViewController *vct3 =  [story instantiateViewControllerWithIdentifier:@"MyCardViewController"];
    vct3.title = @"酱油卡";
    [_viewControllers addObject:vct1];
    [_viewControllers addObject:vct2];
    [_viewControllers addObject:vct3];

    
    if (self.viewControllers.count>0) {
        [self reload];
    }
}
- (NSMutableArray*)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

#pragma mark -- HJHPageViewControllerDataSource,HJHPageViewControllerDelegate

- (NSInteger)numberOfViewControllersInViewPager:(HJHPageViewController *)viewPager
{
    return self.viewControllers.count;
}

- (UIViewController *)viewPager:(HJHPageViewController *)viewPager indexOfViewControllers:(NSInteger)index
{
    return self.viewControllers[index];
}

-(CGFloat)heightForTitleOfViewPager:(HJHPageViewController *)viewPager
{
    return 40.0f;
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
