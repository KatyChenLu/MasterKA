//
//  MasterShareBannerModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DBBaseModel.h"

@interface MasterShareBannerModel : DBBaseModel
@property (nonatomic,strong)NSString *ads_data_id;          //广告id
@property (nonatomic,strong)NSString *title;                //广告标题
@property (nonatomic,strong)NSString *pic_url;              //广告图片
@property (nonatomic,strong)NSString *type;                 //广告类型(1:课程;2:达人;3:课程卡片;4:达人卡片;5:广告通卡;6:html5页面;7内部网页
@property (nonatomic,strong)NSString *content;              //广告内容
@property (nonatomic,strong)NSString *is_login;             //是否需要登录(1需要,0不需要)
@property (nonatomic,strong)NSString *is_open;              //是否原生浏览器打开(1需要,0不需要)
@property (nonatomic,strong)NSString *pfurl;                //需要跳转的url


//@property (nonatomic,strong)NSString *intro;
@end
