//
//  KADetailVoteViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/22.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailVoteViewModel.h"
#import "KADetailVoteTableViewCell.h"
#import "KAInVoteTableViewCell.h"
#import "KAVotePeopleViewController.h"
#import "KADetailViewController.h"
@implementation KADetailVoteViewModel
- (void)initialize {
    [super initialize];
    
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KADetailVoteTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"KAInVoteTableViewCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    
    if (indexPath.section == 0) {
        KAInVoteTableViewCell *cmell = (KAInVoteTableViewCell *)cell;
        [cmell showInVote:object];
    }else{
        
        KADetailVoteTableViewCell *mcell = (KADetailVoteTableViewCell *)cell;
        @weakify(self);
        [mcell setShowVotePeople:^(NSString *itemId,NSString *title) {
            @strongify(self);
            NSLog(@"%@",itemId);
            KAVotePeopleViewController *votePeopleVC = [[KAVotePeopleViewController alloc] init];
            votePeopleVC.item_id = itemId;
            votePeopleVC.title = title;
            [self.viewController pushViewController:votePeopleVC animated:YES];
        }];
        [mcell showKADetailVoteDetail:object];
    }
    
}
-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return @"KAInVoteTableViewCell";
    }else{
          return @"KADetailVoteTableViewCell";
    }
 
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService voteItemDetail:self.vote_id resultClass:nil];
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(NSArray *pageSize) {
        @strongify(self);
                if(self.mTableView.mj_footer.isRefreshing ){
                    [self.mTableView.mj_footer endRefreshing];
                }
                if (self.mTableView.mj_header.isRefreshing) {
                    [self.mTableView.mj_header endRefreshing];
                }
        
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        @strongify(self);
        if (model.code==200) {
            
            
            self.info = model.data;
        
            NSMutableArray*data =[NSMutableArray array];

            [data addObject:[self getTitleView:model.data]];
            [data addObject:model.data[@"item_lists"]];
            
            self.dataSource = data;
            
            [self.mTableView reloadData];
            
        }
        return self.dataSource;
    }];
    
}


- (NSArray *)getTitleView:(NSDictionary *)info {
    NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
    [titleDic setObject:info[@"vote_id"] forKey:@"vote_id"];
    [titleDic setObject:info[@"uid"] forKey:@"uid"];
    [titleDic setObject:info[@"vote_title"] forKey:@"vote_title"];
    [titleDic setObject:info[@"vote_desc"] forKey:@"vote_desc"];
    [titleDic setObject:info[@"end_time"] forKey:@"end_time"];
    [titleDic setObject:info[@"vote_count"] forKey:@"vote_count"];
    [titleDic setObject:info[@"is_end"] forKey:@"is_end"];
    [titleDic setObject:info[@"end_text"] forKey:@"end_text"];
    [titleDic setObject:info[@"item_count"] forKey:@"item_count"];
    
    return @[titleDic];
    
}
#pragma mark --
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth - 12, 50)];
        NSArray *sectionData = self.dataSource[section];
        headerLabel.text = [NSString stringWithFormat:@"%ld个项目进行投票",sectionData.count];
        headerLabel.font = [UIFont systemFontOfSize:14];
        headerLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        headerLabel.backgroundColor = [UIColor whiteColor];
        [header addSubview:headerLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth- 24, 1)];
        line.backgroundColor = RGBFromHexadecimal(0xeaeaea);
        [header addSubview:line];
        return header;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSDictionary *votePeopleData =  self.dataSource[indexPath.section][indexPath.row];
        
        KADetailViewController *kaDetailVC = [[KADetailViewController alloc] init];
        
        kaDetailVC.ka_course_id = votePeopleData[@"ka_course_id"];
            kaDetailVC.headViewUrl = votePeopleData[@"course_cover"];
        
        [self.viewController pushViewController:kaDetailVC animated:YES];
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    

    
    

    
}
@end
