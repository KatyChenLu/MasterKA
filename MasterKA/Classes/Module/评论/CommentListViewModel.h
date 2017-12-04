//
//  CommentListViewModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/28.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface CommentListViewModel : TableViewModel
@property (nonatomic,strong)NSString* shareId;
@property (nonatomic,strong)NSString* commentId;
@property (nonatomic,assign)BOOL isMasterShare;
@property (nonatomic,strong)id replyData;
@property (nonatomic,strong)id sendMessageResult;

@property(nonatomic ,strong)NSString * index_article_id;

@property(nonatomic, strong)NSString * indexRow;

@property (nonatomic,strong,readonly)RACCommand *sendCommentCommand;
@end
