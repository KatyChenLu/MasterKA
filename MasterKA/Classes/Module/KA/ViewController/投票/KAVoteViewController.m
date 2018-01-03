//
//  KAVoteViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/20.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAVoteViewController.h"
#import "KAPreVoteViewController.h"
#import "KAInVoteViewController.h"

@interface KAVoteViewController ()<HJHPageViewControllerDataSource,HJHPageViewControllerDelegate>

@property (nonatomic,strong)NSArray *viewControllerDataSource;
@end

@implementation KAVoteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"投票箱";
    
    self.delegate = self;
    
    self.dataSource = self;
    
    KAPreVoteViewController *preVoteVct = [[KAPreVoteViewController alloc] init];
    preVoteVct.params = @{@"title":@"待发起的投票"};
    KAInVoteViewController *inVoteVct = [[KAInVoteViewController alloc] init];
    inVoteVct.params = @{@"title":@"已发起的投票"};
    
    self.viewControllerDataSource = @[preVoteVct,inVoteVct];
    self.segmentedControl.titleTextAttributes =  @{
                                                   NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                                   NSForegroundColorAttributeName : [[UIColor blackColor] colorWithAlphaComponent:0.5],
                                                   };
    self.segmentedControl.selectedTitleTextAttributes =  @{
                                                           NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
                                                           NSForegroundColorAttributeName : [UIColor blackColor],
                                                           };
    
    self.segmentedControl.selectionIndicatorHeight = 2.0f;
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.verticalDividerEnabled = YES;
    self.segmentedControl.verticalDividerColor = [UIColor colorWithHex:0x9d9d9d];
    self.segmentedControl.verticalDividerWidth = 0.25f;
    
    
    [self reload];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelShare) name:@"cancelShare" object:nil];
}
- (void)cancelShare {
    
    [self setSelectViewPageIndex:1];
    self.segmentedControl.selectedSegmentIndex = 1;

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --

- (NSInteger)numberOfViewControllersInViewPager:(HJHPageViewController *)viewPager
{
    return self.viewControllerDataSource.count;
}

- (UIViewController*)viewPager:(HJHPageViewController *)viewPager indexOfViewControllers:(NSInteger)index
{
    return self.viewControllerDataSource[index];
}

- (CGFloat)heightForTitleOfViewPager:(HJHPageViewController *)viewPager
{
    return 49.0f;
}
- (void)dealloc{
    self.delegate = nil;
    self.dataSource = nil;
    for (UIViewController *vct in self.childViewControllers) {
        [vct removeFromParentViewController];
    }
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelShare" object:nil];
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
