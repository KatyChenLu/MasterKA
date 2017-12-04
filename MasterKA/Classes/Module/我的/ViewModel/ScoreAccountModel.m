//
//  ScoreAccountModel.m
//  MasterKA
//
//  Created by hyu on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ScoreAccountModel.h"
#import "ScoreAccountCell.h"
@implementation ScoreAccountModel
- (void)initialize
{
    [super initialize];
     self.showNoMoreWithAll = YES;
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"ScoreAccountCell";
    [self.mTableView registerCellWithReuseIdentifier:@"ScoreAccountCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getScoreDetialByPage:page pageSize:self.pageSize.integerValue resultClass:nil];
    //    return fetchSignal;
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(id x) {
        NSLog(@"===== x %@",x);
        @strongify(self);
     
        
    }] map:^id(NSArray *responses) {
        NSLog(@"===== value  %@",responses);
        @strongify(self);
        BaseModel *model = responses.firstObject;
        NSArray * array = [NSArray new];
        NSMutableArray * credit = [NSMutableArray new];
        NSMutableArray * dateSection = [NSMutableArray new];

        if (model.code==200) {
            if (![model.data[@"detail"]  isEqual:@""]) array = model.data[@"detail"];
            for (NSDictionary *dic in array) {
                    [credit addObject:[dic objectForKey:@"credit"]];
                    [dateSection addObject:[dic objectForKey:@"month"]];
            }
            //            NSLog(@"%@",order);
            if(credit && credit.count){
                if([self.curPage intValue] > 1){
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithArray:self.dataSource];
                    [_dateSection addObjectsFromArray:dateSection];
                    NSArray *retureArr=[self arrayWithMemberIsOnly:_dateSection];
                    _dateSection=retureArr[0];
                    if([retureArr[1] isEqual:@"NO"]){
                        NSMutableArray * merge1=indexPaths[indexPaths.count-1];
                        [indexPaths removeObjectAtIndex:indexPaths.count-1];
                        NSMutableArray * merge2=credit[0];
                        [credit removeObjectAtIndex:0];
                        [merge1 addObjectsFromArray:merge2];
                        [indexPaths addObject:merge1];
                    }
                     [indexPaths addObjectsFromArray:credit];
                    self.dataSource=indexPaths;
                }else{
                    //                    [self.dbService deleteClass:[BaseModel class]];
                    _dateSection=dateSection;
                    self.dataSource = credit;
                }
                
                [self.mTableView reloadData];
                
                //                [self.dbService deleteClass:array];
                //                [self.dbService insertModelArray:array];
                
            }
            if(self.mTableView.mj_footer.isRefreshing ){
                [self.mTableView.mj_footer endRefreshing];
            }
            if (self.mTableView.mj_header.isRefreshing) {
                [self.mTableView.mj_header endRefreshing];
            }
        }else{
            [self showRequestErrorMessage:model];
//            [self.viewController hiddenHUDWithString:model.message error:NO];
        }
        
        return array;
        
    }];
}
- (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    NSString *identity =@"YES";
    for (int i = 0; i < [array count]; i++) {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO)
            {
                [categoryArray addObject:[array objectAtIndex:i]];
            }else{
                identity =@"NO";
            }
    }
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    [returnArray addObject:categoryArray];
    [returnArray addObject:identity];
    return returnArray;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *Idlabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 40, 0)];
    Idlabel.font=[UIFont systemFontOfSize:14];
    Idlabel.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f  blue:235/255.f  alpha:1.0f];
    Idlabel.text =[NSString stringWithFormat:@"    %@" ,[self.dateSection objectAtIndex:section]];
    Idlabel.textColor=[UIColor colorWithHex:0x333333];
    return Idlabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
- (void)configureCell:(ScoreAccountCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
    //    [cell bindViewModel:[self.info objectAtIndex:indexPath.row]];
//    [cell showMyfans:[self.info objectAtIndex:indexPath.row]];
    [cell showScoreAccount:object];
}

@end
