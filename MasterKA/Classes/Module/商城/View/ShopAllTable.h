//
//  ShopAllTable.h
//  MasterKA
//
//  Created by 余伟 on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCourseModel.h"
#import "CourseModel.h"

@interface ShopAllTable : UITableView

@property(nonatomic ,strong)NSMutableArray * itemModel;

@property(nonatomic ,strong)NSMutableArray * model;

@property(nonatomic ,copy)void(^jumpH5)(NSString *pic_url);

@property(nonatomic ,assign)BOOL ischange;


@end
