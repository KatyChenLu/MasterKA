//
//  MyOrderHomeViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/6/8.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "MyOrderHomeViewController.h"

#import "ZJScrollPageView.h"

@interface MyOrderHomeViewController ()<ZJScrollPageViewDelegate>
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
@property (nonatomic, strong) ZJScrollPageView *scrollPageView;


@end

@implementation MyOrderHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = MasterBackgroundColer;
  [self initHeadViewData];
}

- (void)initHeadViewData{
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    
    style.titleMargin = 20;
    style.autoAdjustTitlesWidth = YES;
    style.selectedTitleColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    style.normalTitleColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    style.scrollLineColor = MasterDefaultColor;
    style.scrollLineHeight = 3;
    style.titleFont = [UIFont systemFontOfSize:16];
    
    if(self.comeIdentifier && [self.comeIdentifier isEqualToString:@"master"]){
        
        self.navigationItem.title=@"订单管理";
        
        self.titles = @[@"全部",
                        @"待接单",
                        @"待验单",
                        @"已拒单"
                        ];
        
        // 初始化
        if (!IsPhoneX) {
            _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 65) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
        }else{
            _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 65 - 34) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
        }
        

        
        UIButton *rightbuton=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightbuton setFrame:CGRectMake(0, 20, 80, 40)];
        [rightbuton setTitle:@"账务统计" forState:UIControlStateNormal];
        [rightbuton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightbuton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        rightbuton.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
        [rightbuton addTarget:self action:@selector(pushToFinancial:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBar =[[UIBarButtonItem alloc]initWithCustomView:rightbuton];
        self.navigationItem.rightBarButtonItem = rightBar;
        
        
    }else{
        
        self.navigationItem.title=@"购课订单";
        
        self.titles = @[@"全部",
                        @"待接单",
                        @"待上课",
                        @"待评价",
                        @"退款"
                        ];
        
        // 初始化
        if (!IsPhoneX) {
            _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 65) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
        }else{
            _scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 65 - 34) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
        }
        

        
        
    }
    
    [self.view addSubview:_scrollPageView];
    
}


- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
     UIViewController *childVc = reuseViewController;
    
    NSString* vctUrl = [NSString stringWithFormat:@"%@",URL_MasterMineOrderList];
    NSString* vctUrl2 = [NSString stringWithFormat:@"%@",URL_MasterMineMasterOrderList];
     if (self.comeIdentifier && [self.comeIdentifier isEqualToString:@"master"]) {
    if (!childVc) {
        childVc  = [self.urlManager viewControllerWithUrl:vctUrl2];
    }
     }else{
         if (!childVc) {
             childVc  = [self.urlManager viewControllerWithUrl:vctUrl];
         }
     }
    
    //达人 0：待接单，1：待评价，4:待上课，5:已退款； 不传默认查询所有订单
    if (self.comeIdentifier && [self.comeIdentifier isEqualToString:@"master"]) {
        
        switch (index) {
            case 0:
                childVc.params = @{@"orderStatus":@"",@"comeIdentifier":self.comeIdentifier};
                break;
            case 1:
                childVc.params = @{@"orderStatus":@"4",@"comeIdentifier":self.comeIdentifier};
                break;
            case 2:
                childVc.params = @{@"orderStatus":@"0",@"comeIdentifier":self.comeIdentifier};
                break;
            case 3:
                childVc.params = @{@"orderStatus":@"5",@"comeIdentifier":self.comeIdentifier};
                break;
            default:
                break;
        }
        

    }else{
        
        switch (index) {
            case 0:
                childVc.params = @{@"orderStatus":@"all",@"comeIdentifier":self.comeIdentifier};
                break;
            case 1:
                childVc.params = @{@"orderStatus":@"4",@"comeIdentifier":self.comeIdentifier};
                break;
            case 2:
                childVc.params = @{@"orderStatus":@"0",@"comeIdentifier":self.comeIdentifier};
                break;
            case 3:
                childVc.params = @{@"orderStatus":@"1",@"comeIdentifier":self.comeIdentifier};
                break;
            case 4:
                childVc.params = @{@"orderStatus":@"5",@"comeIdentifier":self.comeIdentifier};
                break;
            default:
                break;
        }
        

    }
    
    
    //    NSLog(@"%ld-----%@",(long)index, childVc);
    
    return childVc;
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushToFinancial:(id)sender{
    NSString *path = [UserClient sharedUserClient].financial_data_url;
    [self pushViewControllerWithUrl:path];
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
