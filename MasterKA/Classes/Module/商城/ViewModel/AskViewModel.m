//
//  AskViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AskViewModel.h"
//#import "AskTableViewCell.h"
#import "AslListTableViewCell.h"
#import "MasterShareDetailModel.h"
#import "SubCourseModel.h"
#import "AnswerListViewController.h"

@implementation AskViewModel

- (void)initialize {
    [super initialize];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addQuestion) name:@"addQuestion" object:nil];
}

- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"AslListTableViewCell";
    [self.mTableView registerCellWithReuseIdentifier:@"AslListTableViewCell"];
}

- (NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"AslListTableViewCell";
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getAskListWithCourseId:self.courseId Page:page pageSize:self.pageSize.integerValue resultClass:nil];
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(NSArray *pageSize) {
        @strongify(self);
        if (self.mTableView.mj_footer.isRefreshing) {
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        @strongify(self);

        self.info = model.data;
        self.dataSource = @[[NSArray arrayWithArray:model.data[@"list"]]];
        
        [self.mTableView reloadData];
        return self.info;
    }];

}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    AslListTableViewCell *_cell = (AslListTableViewCell *)cell;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_cell showAskList:object];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 13, ScreenWidth - 26, 13)];
    titleLabel.centerY = backGroundView.centerY;
    titleLabel.font = [UIFont systemFontOfSize:14];
    NSDictionary *titletext = self.info[@"course"];
    NSString *count = self.info[@"count"];
    if ([count integerValue] >0) {
        titleLabel.text = [NSString stringWithFormat:@"关于%@的%@个问题",titletext[@"title"],self.info[@"count"]];
    }
    
    [backGroundView addSubview:titleLabel];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 1)];
    lineView.backgroundColor =  [UIColor colorWithRed:235/255.f green:235/255.f  blue:235/255.f  alpha:1.0f];
    [backGroundView addSubview:lineView];
    return backGroundView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 41;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    AnswerListViewController *answerListVC = [story instantiateViewControllerWithIdentifier:@"QuestionDetailViewController"];
    NSArray *infolist = self.info[@"list"];
    NSDictionary *infoDic = infolist[indexPath.row];
    answerListVC.params = @{@"question_id":infoDic[@"question_id"]};
    [self.viewController pushViewController:answerListVC animated:YES];
}
@end
