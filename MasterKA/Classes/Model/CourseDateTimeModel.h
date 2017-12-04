//
//  CourseDateTimeModel.h
//  MasterKA
//
//  Created by jinghao on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseTimeModel : NSObject

@property (nonatomic,strong)NSString *end_time;
@property (nonatomic,strong)NSString *timeId;
@property (nonatomic,strong)NSString *num;
@property (nonatomic,strong)NSString *remain_num;
@property (nonatomic,strong)NSString *start_time;
@property (nonatomic,assign)BOOL selected;
@property (nonatomic,assign)NSInteger selectedNum;

@end

@interface CourseDateTimeModel : NSObject
@property (nonatomic,strong)NSString *course_cfg_id;
@property (nonatomic,strong)NSString *is_full;
@property (nonatomic,strong)NSString *start_date;
@property (nonatomic,strong)NSArray *time_list;

@property (nonatomic,strong,readonly)NSString *startDateShortStr;
@property (nonatomic,strong,readonly)NSDate *startDate;


@end
