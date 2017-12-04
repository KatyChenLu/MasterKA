//
//  SubCourseModel.h
//  MasterKA
//
//  Created by xmy on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCourseModel : NSObject

@property (nonatomic,strong)NSString *subject_id;//课程id
@property (nonatomic,strong)NSString *cover;//专题封面图
@property (nonatomic,strong)NSString *pfurl;//专题封面图
@property (nonatomic,strong)NSArray *course_list;


@end
