//
//  MapModel.h
//  MasterKA
//
//  Created by 余伟 on 16/12/16.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseModel.h"

@interface MapModels : BaseModel

@property(nonatomic ,copy)NSString * category_id;//二级分类id
@property(nonatomic ,copy)NSString * category_name;//二级分类名称
@property(nonatomic ,copy)NSString * course_id;//课程编号
@property(nonatomic ,copy)NSString * cover;//课程封面图
@property(nonatomic ,copy)NSString * distance;//距离
@property(nonatomic ,copy)NSString * lat;//维度
@property(nonatomic ,copy)NSString * lng;//经度
@property(nonatomic ,copy)NSString * p_category_id;//一级分类id
@property(nonatomic ,copy)NSString * p_category_name;//一级分类名称
@property(nonatomic ,copy)NSString * pfurl;//链接
@property(nonatomic ,copy)NSString * store;//课程门店
@property(nonatomic ,copy)NSString * title;//课程标题
@property(nonatomic ,copy)NSString * category_pic_url;



@end
