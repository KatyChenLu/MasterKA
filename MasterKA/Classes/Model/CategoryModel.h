//
//  CategoryModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBaseModel.h"

@interface CategoryModel : DBBaseModel
@property (nonatomic,strong)NSString *categoryId;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *pic_url;

@end
