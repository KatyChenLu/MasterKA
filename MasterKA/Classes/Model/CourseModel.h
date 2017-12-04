//
//  CourseModel.h
//  MasterKA
//
//  Created by jinghao on 16/5/9.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject
@property (nonatomic,strong)NSString *course_id;
@property (nonatomic,strong)NSString *cover;
@property (nonatomic,strong)NSString *view_count;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *is_mpay;//1是M点课程 0是现金课程
@property (nonatomic,strong)NSString *m_price;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *market_price;
@property (nonatomic,strong)NSString *show_market_price;
@property (nonatomic,strong)NSString *store;
@property (nonatomic,strong)NSString *nikename;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *distance;
@property (nonatomic,strong)NSArray *tags;
@property (nonatomic,strong)NSString *is_enterprise;//是否是企业课
@property(nonatomic ,strong)NSString * is_groupbuy;//是够是团购课
@property(nonatomic ,strong)NSString *groupbuy_tip;//团购推语


- (NSString*)getPriceString;
- (NSString*)getMakertPriceString;

@end
