//
//  UserShareModel.h
//  MasterKA
//
//  Created by xmy on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DBBaseModel.h"


@interface UserShareModel : DBBaseModel


@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *browse_count;
@property (nonatomic,strong)NSString *city ;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *cover ;
@property (nonatomic,strong)NSString *img_top;
@property (nonatomic,strong)NSString *like_count;
@property (nonatomic,strong)NSString *nikename ;
@property (nonatomic,strong)NSString *province ;
@property (nonatomic,strong)NSString *title ;
@property (nonatomic,strong)NSString *share_id;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSArray *detail;
@property (nonatomic,strong)NSString *detailJSON;

@end

RLM_ARRAY_TYPE(UserShareModel)
