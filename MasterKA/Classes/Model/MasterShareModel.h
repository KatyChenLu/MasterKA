//
//  MasterShareModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DBBaseModel.h"

@interface MasterShareModel : NSObject
@property (nonatomic,strong)NSString *category_id;      //分类ID
@property (nonatomic,strong)NSString *share_id;         //分享ID
@property (nonatomic,strong)NSString *title;            //标题
@property (nonatomic,strong)NSString *content;          //分享内容
@property (nonatomic,strong)NSString *cover;            //分享图片
@property (nonatomic,strong)NSString *tag_name;         //自定义标签名称
@property (nonatomic,strong)NSString *tag_id;           //表情ID
@property (nonatomic,strong)NSString *like_count;       //点赞量
@property (nonatomic,strong)NSString *browse_count;     //浏览量
@property (nonatomic,strong)NSString *uid;              //用户ID
@property (nonatomic,strong)NSString *nikename;         //昵称
@property (nonatomic,strong)NSString *img_top;          //用户头像

@property(nonatomic,strong)NSString*master;

@property(nonatomic,strong)NSString*comment_count;

@property(nonatomic,strong)NSString* identity;
@property(nonatomic,strong)NSString* province;
@property(nonatomic,strong)NSString* city;
@property(nonatomic,strong)NSString*address;
@property(nonatomic,strong)NSString*is_like;
@property(nonatomic,strong)NSString*time;
@property(nonatomic,strong)NSString* is_mine;
@property(nonatomic,strong)NSArray*detail;
@property(nonatomic,strong)NSArray*like_list;
@property(nonatomic,strong)NSMutableArray*comment_list;

@end


