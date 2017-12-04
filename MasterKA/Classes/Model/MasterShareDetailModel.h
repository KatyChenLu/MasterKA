//
//  MasterShareDetailModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseModel.h"


@interface MasterShareDetailModel : BaseModel
@property (nonatomic,strong)NSMutableDictionary *share;
@property (nonatomic,strong)NSMutableDictionary *course;
@property (nonatomic,strong)NSMutableDictionary *user;
@property (nonatomic,strong)NSMutableDictionary *share_data;
@property (nonatomic,strong)NSMutableArray *comment_list;
@property (nonatomic,strong)NSString *next_share_id;
@property (nonatomic,strong)NSArray *enterprise_share_picture_list;//企业分享照片
@property (nonatomic,strong)NSString * company_photo;
@end

//@interface clShareModel : BaseModel
//@property (nonatomic, copy)NSString *like_count;
//@property (nonatomic, copy)NSString *company_id;
//@property (nonatomic, copy)NSString *share_data;
//@property (nonatomic,strong)NSMutableArray *detail;
//@property (nonatomic, copy)NSString *is_like;
//@property (nonatomic, copy)NSString *comment_count;
//@property (nonatomic, copy)NSString *next_share_id;
//@property (nonatomic, copy)NSString *title;
//@property (nonatomic, copy)NSString *content;
//@property (nonatomic, copy)NSString *tag_name;
//@property (nonatomic, copy)NSString *tag_id;
//
//@end
