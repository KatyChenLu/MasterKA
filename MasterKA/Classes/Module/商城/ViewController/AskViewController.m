//
//  AskViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/9.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AskViewController.h"

#import "AskViewModel.h"
#import "AskQuestionViewController.h"

@interface AskViewController (){
    AppDelegate *appdelegate;
}

@property (nonatomic, strong)AskViewModel *viewModel;

@end

@implementation AskViewController
@synthesize viewModel = _viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问大家";
    self.viewModel.title = @"问大家";
//     self.viewModel.identifier=@"AslListTableViewCell";
    self.viewModel.courseId = self.params[@"course_id"];
    [self.viewModel bindTableView:self.mTableView];
     appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.mTableView reloadData];
    [self.viewModel first];
}

- (AskViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[AskViewModel alloc] initWithViewController:self];
    }
    return _viewModel;
}


- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [[self.askButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if ([(BaseViewController *)appdelegate.baseVC doLogin]) {
            
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
        AskQuestionViewController *askQuestionVC = [story instantiateViewControllerWithIdentifier:@"AskQuestionViewController"];
            askQuestionVC.params = @{@"title":self.params[@"title"],@"course_id":self.params[@"course_id"]};
        [self pushViewController:askQuestionVC animated:YES];
            
        }
    }];
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
