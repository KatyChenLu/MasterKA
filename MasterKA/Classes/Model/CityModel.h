//
//  CityModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBaseModel.h"
@interface CityModel : DBBaseModel
@property (nonatomic,strong)NSString *city_name;
@property (nonatomic,strong)NSString *city_code;

@property (nonatomic,strong)NSString *alias_name;
@property (nonatomic,strong)NSString *pingyin;
@property (nonatomic,strong)NSString *pic_url;
@end
