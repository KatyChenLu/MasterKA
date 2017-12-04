//
//  MineOrderHomeVC.m
//  MasterKA
//
//  Created by hyu on 16/5/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MineOrderHomeVC.h"
#import "MineOrdersViewController.h"

@interface MineOrderHomeVC ()<HJHPageViewControllerDelegate,HJHPageViewControllerDataSource>

@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, strong) NSString *comeIdentifier;

@end

@implementation MineOrderHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    self.comeIdentifier = self.params[@"comeIdentifier"];
    
    self.segmentedControl.titleTextAttributes =  @{
                                                   NSFontAttributeName : [UIFont systemFontOfSize:18.0f],
                                                   NSForegroundColorAttributeName : [UIColor colorWithHex:0x737373],
                                                   };
    self.segmentedControl.selectedTitleTextAttributes =  @{
                                                           NSFontAttributeName : [UIFont systemFontOfSize:18.0f],
                                                           NSForegroundColorAttributeName : [UIColor colorWithHex:0x737373],
                                                           };
    
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0xa52040];
    self.segmentedControl.selectionIndicatorHeight = 1.0f;
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -6, 0);

    
    [self initHeadViewData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHeadViewData{
    
    if(self.comeIdentifier && [self.comeIdentifier isEqualToString:@"master"]){
        NSString* vctUrl = [NSString stringWithFormat:@"%@",URL_MasterMineMasterOrderList];
        //达人 0：待接单，1：待评价，4:待上课，5:已退款； 不传默认查询所有订单
        UIViewController *vct1 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct1.params = @{@"orderStatus":@"",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct1.title = @"全部";
        
        UIViewController *vct2 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct2.params = @{@"orderStatus":@"4",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct2.title = @"待接单";
        
        UIViewController *vct3 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct3.params = @{@"orderStatus":@"0",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct3.title = @"待验单";
        
        UIViewController *vct4 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct4.params = @{@"orderStatus":@"5",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct4.title = @"已拒单";
        
        
        self.navigationItem.title=@"订单管理";
        
        
        UIButton *rightbuton=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightbuton setFrame:CGRectMake(0, 20, 80, 40)];
        [rightbuton setTitle:@"账务统计" forState:UIControlStateNormal];
        [rightbuton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightbuton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        rightbuton.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
        [rightbuton addTarget:self action:@selector(pushToFinancial:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:rightbuton];
        self.navigationItem.rightBarButtonItem = rightBar;
       
        [self.viewControllers addObject:vct1];
        [self.viewControllers addObject:vct2];
        [self.viewControllers addObject:vct3];
        [self.viewControllers addObject:vct4];
        
        
    }else{
        NSString* vctUrl = [NSString stringWithFormat:@"%@",URL_MasterMineOrderList];
        
        UIViewController *vct1 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct1.params = @{@"orderStatus":@"all",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct1.title = @"全部";
        
        UIViewController *vct2 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct2.params = @{@"orderStatus":@"4",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct2.title = @"待接单";
        
        UIViewController *vct3 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct3.params = @{@"orderStatus":@"0",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct3.title = @"待上课";

        
        UIViewController *vct4 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct4.params = @{@"orderStatus":@"1",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct4.title = @"待评价";
        
        UIViewController *vct5 = [self.urlManager viewControllerWithUrl:vctUrl];
        vct5.params = @{@"orderStatus":@"5",@"comeIdentifier":self.params[@"comeIdentifier"]};
        vct5.title = @"退款";
        
        self.navigationItem.title=@"购课订单";
        [self.viewControllers addObject:vct1];
        [self.viewControllers addObject:vct2];
        [self.viewControllers addObject:vct3];
        [self.viewControllers addObject:vct4];
        [self.viewControllers addObject:vct5];
    }
    
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
-(void)pushToFinancial:(id)sender{
    NSString *path = [UserClient sharedUserClient].financial_data_url;
    [self pushViewControllerWithUrl:path];
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





@end
