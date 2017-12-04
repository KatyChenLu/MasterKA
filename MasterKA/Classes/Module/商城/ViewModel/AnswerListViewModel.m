//
//  AnswerListViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AnswerListViewModel.h"
#import "AskDetailTableViewCell.h"

@implementation AnswerListViewModel

- (void)initialize {
    [super initialize];
    
}

- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"AskDetailTableViewCell";
    [self.mTableView registerCellWithReuseIdentifier:@"AskDetailTableViewCell"];
}

- (NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return @"AskDetailTableViewCell";
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getAnswerListWithQuestionId:self.questionId Page:page pageSize:self.pageSize.integerValue resultClass:nil];
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
    AskDetailTableViewCell *_cell = (AskDetailTableViewCell *)cell;
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_cell showAskDetailList:object];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 31)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, ScreenWidth - 26, 13)];
    titleLabel.centerY = backGroundView.centerY;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = [NSString stringWithFormat:@"共%@个答案",self.info[@"count"]];
    [backGroundView addSubview:titleLabel];
    
    UIImageView *answerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"answer"]];
    answerImgView.frame = CGRectMake(13, 10, 18, 18);
    answerImgView.centerY = backGroundView.centerY;
    [backGroundView addSubview:answerImgView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 1)];
    lineView.backgroundColor =  [UIColor colorWithRed:235/255.f green:235/255.f  blue:235/255.f  alpha:1.0f];
    [backGroundView addSubview:lineView];
    return backGroundView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 31;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
//    QuestionDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"QuestionDetailViewController"];
//    [self.viewController pushViewController:myView animated:YES];
}

@end
