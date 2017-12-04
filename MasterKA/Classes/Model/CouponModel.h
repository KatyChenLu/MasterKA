//
//  CouponModel.h
//  MasterKA
//
//  Created by 余伟 on 16/12/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseModel.h"

@interface CouponModel : BaseModel

@property(nonatomic ,copy)NSString * coupon_id;//一级分类id
@property(nonatomic ,copy)NSString * price;//一级分类id
@property(nonatomic ,copy)NSString * pic_url;//图片Url
@property(nonatomic ,copy)NSString * status;


@end
