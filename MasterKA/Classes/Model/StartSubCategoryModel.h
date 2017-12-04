//
//  StartSubCategoryModel.h
//  MasterKA
//
//  Created by 余伟 on 16/12/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseModel.h"

@interface StartSubCategoryModel : BaseModel

@property(nonatomic ,copy)NSString * ID;//二级分类id
@property(nonatomic ,copy)NSString * name;//分类名称
@property(nonatomic ,copy)NSString * intro;//分类简介
@property(nonatomic ,copy)NSString * pic_url;//分类图标
@property(nonatomic ,copy)NSString * pid;//一级分类id
@property(nonatomic ,assign)BOOL     select;



@end
