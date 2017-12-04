//
//  MasterShareHotModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DBBaseModel.h"

@interface MasterShareHotModel : DBBaseModel
@property (nonatomic,strong)NSString *uid;              //达人ID
@property (nonatomic,strong)NSString *nikename;         //昵称
@property (nonatomic,strong)NSString *img_top;          //头像
@property (nonatomic,strong)NSString *intro;            //达人简介
@property (nonatomic,strong)NSString *fans;             //达人粉丝量
@property (nonatomic,strong)NSString *is_follow;        //是否关注(1关注，0未关注)

@property (nonatomic,assign)BOOL isFollow;        //是否关注(1关注，0未关注)

@end
