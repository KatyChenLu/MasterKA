//
//  MineMasterOrderListVC.h
//  MasterKA
//
//  Created by xmy on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

#import "ZJScrollPageViewDelegate.h"
@interface MineMasterOrderListVC : BaseViewController<ZJScrollPageViewChildVcDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
