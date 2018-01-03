//
//  KAOrdersViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/28.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrdersViewController.h"
#import "KAOrdersViewModel.h"

@interface KAOrdersViewController ()
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) KAOrdersViewModel *viewModel;
@property (nonatomic, strong) UIButton *teleBtn;
@end
@implementation KAOrdersViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mTableView];
    self.title = @"团建订单";
    [self.viewModel bindTableView:self.mTableView];
    
    UIBarButtonItem *shoucangBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.teleBtn];
    
    self.navigationItem.rightBarButtonItem =shoucangBarBtnItem;
}
- (void)bindViewModel {
    [super bindViewModel];
    
}
- (UIButton *)teleBtn {
    if (!_teleBtn) {
        _teleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_teleBtn setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [_teleBtn addTarget:self action:@selector(teleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _teleBtn;
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 44):0) - 49) style:UITableViewStylePlain];
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _mTableView.separatorColor = RGBFromHexadecimal(0xeaeaea);
    }
    return _mTableView;
}

- (KAOrdersViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAOrdersViewModel alloc] initWithViewController:self
                      ];
        
    }
    return _viewModel;
}
- (void)teleButtonOnClick:(NSString*)phones {
        phones = [UserClient sharedUserClient].server_number;
        NSString* courseMobile = phones;
        courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"、" withString:@","];
        courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"，" withString:@","];
        NSArray* phonesArray = [courseMobile componentsSeparatedByString:@","];
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        actionSheet.title = @"电话号码";
        [actionSheet addButtonWithTitle:@"取消"];
        for (NSString* phone in phonesArray) {
            [actionSheet addButtonWithTitle:phone];
        }
        [actionSheet setCancelButtonIndex:0];
        [actionSheet showInView:self.view];
        [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
            if (index.integerValue>0) {
                NSString* phone = [actionSheet buttonTitleAtIndex:index.integerValue];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
            }
        } ];
    
}
- (void)gotoBack{
    if(self.isFromCustom ){
        [self gotoBack:YES viewControllerName:@"KAHomeViewController"];
    }
    else{
        
        if ([self canGotoBack]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
