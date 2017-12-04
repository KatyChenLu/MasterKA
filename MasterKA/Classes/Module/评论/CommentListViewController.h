//
//  CommentListViewController.h
//  MasterKA
//
//  Created by jinghao on 16/4/28.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"


@interface CommentListViewController : BaseViewController
@property (nonatomic,strong)NSString* couresId;//课程ID
@property (nonatomic,strong)NSString* currentTime;//开始加载时间
@property (nonatomic,strong)NSString* type;//分类标示

@property(nonatomic ,copy)NSString* index_article_id;


@end
