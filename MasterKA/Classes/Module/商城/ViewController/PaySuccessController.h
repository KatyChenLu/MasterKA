//
//  PaySuccessController.h
//  MasterKA
//
//  Created by 余伟 on 16/8/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
#import "HttpManagerCenter.h"

@interface PaySuccessController : BaseViewController


@property(nonatomic, strong)NSDictionary * orderInfo;

@property(nonatomic , assign)BOOL isBuy;


@end
