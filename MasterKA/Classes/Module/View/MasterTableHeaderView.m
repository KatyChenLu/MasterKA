//
//  MasterTableHeaderView.m
//  MasterKA
//
//  Created by jinghao on 16/1/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterTableHeaderView.h"

@implementation MasterTableHeaderView


+(MJRefreshGifHeader*)addRefreshGifHeadViewWithRefreshBlock:(void(^)())refresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
       
        refresh();
        
    }];
    
    NSMutableArray * arr = [@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"],[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8"],[UIImage imageNamed:@"9"],[UIImage imageNamed:@"10"],[UIImage imageNamed:@"11"],[UIImage imageNamed:@"12"],[UIImage imageNamed:@"13"],[UIImage imageNamed:@"14"],[UIImage imageNamed:@"15"],[UIImage imageNamed:@"16"],[UIImage imageNamed:@"17"],[UIImage imageNamed:@"18"],[UIImage imageNamed:@"19"],[UIImage imageNamed:@"20"]]mutableCopy];
    
   [header setImages:arr forState:MJRefreshStateRefreshing];
    [header setImages:@[[UIImage imageNamed:@"12"]] forState:MJRefreshStateIdle];
    [header setImages:@[[UIImage imageNamed:@"13"]] forState:MJRefreshStatePulling];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    
    
    return header;
}




-(void)loadNewData
{
    
//    BOOL responds = [self.delegate respondsToSelector:@selector(masterTableHeaderViewloadNewData:)];
    
    if ([self.delegate respondsToSelector:@selector(masterTableHeaderViewloadNewData:)]) {
        
        [self.delegate masterTableHeaderViewloadNewData:self];
    }
    
    
}








@end
