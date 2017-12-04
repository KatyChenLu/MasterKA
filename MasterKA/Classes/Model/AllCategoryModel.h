//
//  AllCategoryModel.h
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseModel.h"

@interface AllCategoryModel : BaseModel

@property(nonatomic ,copy)NSString * name;
@property(nonatomic ,copy)NSString * pic_url;
@property(nonatomic ,strong)NSArray * sub_category_list;
@property(nonatomic ,copy)NSString * ID;


@end
