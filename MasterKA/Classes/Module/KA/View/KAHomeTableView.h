//
//  KAHomeTableView.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAHomeModel.h"
#import "KAHomeViewController.h"
#import "KAFilterViewController.h"
#import "BaseViewController.h"

@interface KAHomeTableView : UITableView
@property (nonatomic, strong) NSMutableArray *kaHomeData;

@property (nonatomic, strong)BaseViewController * baseVC;

@property (nonatomic, assign)BOOL isShowCusBtn;

@property(nonatomic ,assign)BOOL isChange;
- (void)logoutAction;


@end
