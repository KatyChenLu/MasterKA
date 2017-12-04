//
//  CategoryUserModel.h
//  MasterKA
//
//  Created by 余伟 on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DBBaseModel.h"

@interface CategoryUserModel : DBBaseModel

@property(nonatomic ,copy)NSString * category_list_id ;

@property(nonatomic ,copy)NSString * name;

@property(nonatomic ,copy)NSString * pic_url;

@end
