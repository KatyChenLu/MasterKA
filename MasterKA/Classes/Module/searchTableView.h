//
//  searchTableView.h
//  MasterKA
//
//  Created by lijiachao on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MasterShareListModel.h"
#import "MasterSearchListModel.h"
#import "SendMessageModel.h"


@interface searchTableView : UITableView

@property(nonatomic,assign)NSInteger mtableRfreshId;
@property(nonatomic,strong)MasterSearchListModel* shareTableList;
@property(nonatomic,strong)MasterSearchListModel* shareTableList2;
@property(nonatomic,strong)MasterSearchListModel* shareTableList3;

@property(nonatomic,strong)UIButton* mostHostBtn;
@property(nonatomic,strong)UIButton* newestBtn;
@property(nonatomic,strong)UIButton*guanzhuBtn;
@property(nonatomic,assign)int currentTag;
@property(nonatomic,assign)CGFloat yy;
@property(nonatomic,assign) BOOL first1;
@property(nonatomic,assign) BOOL first2;
@property(nonatomic,assign) BOOL first3;
@property(nonatomic,assign)BOOL btnChanged;
@property(nonatomic,assign)BOOL isOnTop;
@property (nonatomic, copy) void (^NextViewControllerBlock)(int tag);

@property (nonatomic,strong)NSDictionary *sendMessageModel;
@property (nonatomic,copy)NSString *indexRow;
- (void)addCommentWithSendMessage:(NSDictionary *)sendMessage indexRow:(NSString *)row;
@end
