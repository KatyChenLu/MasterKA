//
//  AppConfigModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfigModel : NSObject
@property (nonatomic,strong)NSArray *city_list;
@property (nonatomic,strong)NSArray *course_time;
@property (nonatomic,strong)NSArray *sence;
@property (nonatomic,strong)NSString *course_price_min;
@property (nonatomic,strong)NSString *course_price_max;
@property (nonatomic,strong)NSString *people_num_min;
@property (nonatomic,strong)NSString *people_num_max;
@property (nonatomic,strong)NSString *about_us_url;
@property (nonatomic,strong)NSString *agree_url;
@property (nonatomic,strong)NSDictionary *requirement;
@property (nonatomic,strong)NSString *server_number;



//@property (nonatomic,strong)NSArray *city_list;
//@property (nonatomic,strong)NSArray *category_list;
//@property (nonatomic,strong)NSArray *superscript_list;
//@property (nonatomic,strong)NSArray *interest_list;
//@property (nonatomic,strong)NSArray *order_type;
//@property (nonatomic,strong)NSArray *select_type;
//@property (nonatomic,strong)NSArray *order_refund_msg;
//@property (nonatomic,strong)NSString *enterprise_course_url;//企业课链接
//@property (nonatomic,strong)NSString *master_enter_url;//达人入驻链接
//@property (nonatomic,strong)NSString *financial_data_url;//财务统计链接
//@property (nonatomic,strong)NSString *about_us_url;//关于我们链接
//@property (nonatomic,strong)NSString *about_card_url;//酱油卡说明链接
//@property (nonatomic,strong)NSString *agree_url;//使用协议链接
//@property (nonatomic,strong)NSString *activity_url;//活动链接
@property (nonatomic,strong)NSDictionary *start_ads;//启动封面广告
@property (nonatomic,strong)NSDictionary *start_small_ads;//弹出框广告
//@property (nonatomic,strong)NSArray * category_user_list;



@end
