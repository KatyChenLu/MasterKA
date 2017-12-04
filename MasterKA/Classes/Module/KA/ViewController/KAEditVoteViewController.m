//
//  KAEditVoteViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAEditVoteViewController.h"
#import "MasterTextfield.h"
#import "MStringPickerView.h"
#import "KAProViewModel.h"

@interface KAEditVoteViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UIView *headView;
@property (nonatomic, strong)UITextView *titleTextView;
@property (nonatomic, strong)UITextView *describeTextView;
@property (nonatomic, strong) MasterTextfield *timeTF;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIButton *beginVoteBtn;


@property (nonatomic, strong) KAProViewModel *viewModel;
@end

@implementation KAEditVoteViewController
@synthesize viewModel = _viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑投票";
    
    [self.view addSubview:self.headView];
    
    [self.view addSubview:self.beginVoteBtn];
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
        make.bottom.equalTo(self.beginVoteBtn.mas_top);
    }];
    
    [self.viewModel bindTableView:self.mTableView];
    
    
    RAC(self.beginVoteBtn,enabled) = [RACSignal combineLatest:@[self.titleTextView.rac_textSignal] reduce:^id(NSString *title){
        return @(title.length);
    }];
}
- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] init];
        
    }
    return _mTableView;
}
- (UIButton *)beginVoteBtn {
    if (!_beginVoteBtn) {
        _beginVoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beginVoteBtn.frame = CGRectMake(0, ScreenHeight - (IsPhoneX?(34 + 44):0)-42 -44,  ScreenWidth, 42);
        [_beginVoteBtn setBackgroundImage:[UIImage imageWithColor:MasterDefaultColor] forState:UIControlStateNormal];
          [_beginVoteBtn setBackgroundImage:[UIImage imageWithColor:RGBFromHexadecimal(0xcdcdcd)] forState:UIControlStateDisabled];
        NSString *btnTitle =@"发布投票";
        _beginVoteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_beginVoteBtn setTitle:btnTitle forState:UIControlStateNormal];
        [_beginVoteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_beginVoteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
              [self shareContentOfApp:nil];
        }];
    }
    return _beginVoteBtn;
}
- (KAProViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[KAProViewModel alloc] initWithViewController:self
                      ];
        _viewModel.isHideSelect = YES;
    }
    return _viewModel;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 182)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        UIView *titleView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        titleView.backgroundColor = [UIColor whiteColor];
        _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 18, ScreenWidth - 12*2, 60-18)];
        _titleTextView.text = @"xxx发起的投票";
//        _titleTextView.placeholderColor = [UIColor blackColor];
        _titleTextView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        [titleView addSubview:_titleTextView];
        [_headView addSubview:titleView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, 1)];
        [_headView addSubview:lineView];
        
        UIView *describeView =[[UIView alloc] initWithFrame:CGRectMake(0, 61, ScreenWidth, 60)];
        describeView.backgroundColor = [UIColor whiteColor];
        _describeTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 20, ScreenWidth - 12*2, 60-20)];
        _describeTextView.placeholderStr = @"补充描述";
        _describeTextView.font = [UIFont systemFontOfSize:14];
        [describeView addSubview:_describeTextView];
        [_headView addSubview:describeView];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 121, ScreenWidth, 1)];
        [_headView addSubview:lineView2];
        
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 122, ScreenWidth, 60)];
        timeView.backgroundColor = [UIColor whiteColor];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 100, 20)];
        timeLabel.text = @"投票倒计时";
        timeLabel.font = [UIFont systemFontOfSize:14];
        [timeView addSubview:timeLabel];
        [_headView addSubview:timeView];
        
        _timeTF = [[MasterTextfield alloc] initWithFrame:CGRectMake(ScreenWidth - 230, 18, 200, 30)];
        _timeTF.backgroundColor = [UIColor clearColor];
        _timeTF.font = [UIFont systemFontOfSize:14.0f];
        _timeTF.textAlignment = NSTextAlignmentRight;
        _timeTF.textColor = RGBFromHexadecimal(0x666666);
        _timeTF.delegate = self;
        [timeView addSubview:_timeTF];
        _timeTF.placeholder = @"1天0个小时";
        __weak typeof(self) weakSelf = self;
        _timeTF.tapActionBlock = ^{
            NSArray *dataSources = @[@[@"1天", @"2天", @"3天", @"4天", @"5天", @"6天", @"7天"], @[@"0个小时",@"1个小时", @"2个小时", @"3个小时", @"4个小时", @"5个小时", @"6个小时", @"7个小时",@"8个小时",@"9个小时",@"10个小时",@"11个小时",@"12个小时",@"13个小时",@"14个小时",@"15个小时",@"16个小时",@"17个小时",@"18个小时",@"19个小时",@"20个小时",@"21个小时",@"22个小时",@"23个小时"]];
            [MStringPickerView showStringPickerWithTitle:@"投票时间" dataSource:dataSources defaultSelValue:@[@"1天",@"0个小时"] isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.timeTF.text = [NSString stringWithFormat:@"%@%@", selectValue[0], selectValue[1]];
            }];
        };
        
        UIImageView *youImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"向右"]];
        youImgV.frame =CGRectMake(ScreenWidth - 20, 0, 6, 12);
        youImgV.centerY = _timeTF.centerY;
        [timeView addSubview:youImgV];
        
        UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 182, ScreenWidth, 1)];
        [_headView addSubview:lineView3];
        
        UILabel *chooseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 202, 100, 20)];
        chooseNumLabel.text = @"已选择3项";
        chooseNumLabel.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        chooseNumLabel.font = [UIFont systemFontOfSize:14];
       
        [_headView addSubview:chooseNumLabel];
        
    }
    return _headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
        [textField resignFirstResponder];
    
    return YES;
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
