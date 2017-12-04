//
//  MyOrderViewController.h
//  HiGoMaster
//
//  Created by jinghao on 15/6/4.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseViewController.h"


@interface MyOrderViewController : BaseViewController
@property (nonatomic,strong)NSString*  masterOrder;
//用户 0：待接单，1：待评价，4:待上课，5:已退款； 不传默认查询所有订单
//达人 0：待接单，1：待评价，4:待上课，5:已退款； 不传默认查询所有订单
@property (nonatomic,strong)NSString* orderType;


@end
