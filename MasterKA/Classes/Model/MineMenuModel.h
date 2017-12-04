//
//  MineMenuModel.h
//  MasterKA
//
//  Created by jinghao on 16/2/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DBBaseModel.h"

@interface MineMenuModel : DBBaseModel
@property (nonatomic,strong)NSString *icon;     //图标
@property (nonatomic,strong)NSString *title;    //标题
@property (nonatomic,strong)NSString *badge;    //未读数量
@property (nonatomic,assign)NSInteger groupId;    //分组序号
@property (nonatomic,strong)NSString *params;    //需要请求的参数
@property (nonatomic,assign)NSInteger orderNum;    //排序
@property (nonatomic,strong)NSString *url;    //排序
@property (nonatomic,assign)NSInteger isNew;    //排序

@end
