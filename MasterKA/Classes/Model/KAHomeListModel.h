//
//  KAHomeListModel.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/4.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KAHomeListModel : NSObject

@property (nonatomic,strong)NSString *ka_course_id;
@property (nonatomic,strong)NSString *course_cover;
@property (nonatomic,strong)NSString *course_title;
@property (nonatomic,strong)NSString *course_sub_title;
@property (nonatomic,strong)NSString *course_time;
@property (nonatomic,strong)NSString *course_price;
@property (nonatomic,strong)NSString *city_code;
@property (nonatomic,strong)NSString *people_num;
@property (nonatomic,strong)NSString *is_vote_cart;
@property (nonatomic,strong)NSArray *tags_name;

@end
