//
//  HostManShareModel.h
//  MasterKA
//
//  Created by lijiachao on 16/9/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DBBaseModel.h"

@interface HostManShareModel : DBBaseModel
@property (nonatomic,strong)NSString *uid;              //达人ID
@property (nonatomic,strong)NSString *nikename;         //昵称
@property (nonatomic,strong)NSString *img_top;          //头像
@property (nonatomic,strong)NSString *intro;            //达人简介
@property (nonatomic,strong)NSString *fans;             //达人粉丝量
@property (nonatomic,strong)NSString *is_follow;        //是否关注(1关注，0未关注)
@property (nonatomic,strong)NSString*first_photo;
@property (nonatomic,strong)NSString*second_photo;
@property (nonatomic,strong)NSString*third_photo;

@property (nonatomic,assign)BOOL isFollow;        //是否关注(1关注，0未关注)

@end
