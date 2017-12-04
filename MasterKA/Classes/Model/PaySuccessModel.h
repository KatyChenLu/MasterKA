//
//  PaySuccessModel.h
//  MasterKA
//
//  Created by 余伟 on 16/9/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserListModel.h"

@interface PaySuccessModel : NSObject

@property(nonatomic, strong)NSDictionary *Course;

@property(nonatomic ,copy)NSString * current_time;
@property(nonatomic ,copy)NSString * groupbuy_endtime;
@property(nonatomic ,copy)NSString * groupbuy_num;
@property(nonatomic ,copy)NSString * groupbuy_price;
@property(nonatomic ,copy)NSString * is_groupbuy;
@property(nonatomic ,strong)NSArray * user;

@end
