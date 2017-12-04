//
//  MasterTableHeaderView.h
//  MasterKA
//
//  Created by jinghao on 16/1/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterTableHeaderView;

@protocol MasterTableHeaderViewDelegate <NSObject>


-(void)masterTableHeaderViewloadNewData:(MasterTableHeaderView *)MasterTableHeaderView;

@end

@interface MasterTableHeaderView : MJRefreshGifHeader

@property(nonatomic ,weak)id delegate;

+(MJRefreshGifHeader*)addRefreshGifHeadViewWithRefreshBlock:(void(^)())refresh;
@end
