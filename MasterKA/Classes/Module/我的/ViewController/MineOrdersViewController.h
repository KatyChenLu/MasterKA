//
//  MineOrdersViewController.h
//  MasterKA
//
//  Created by hyu on 16/5/5.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseTableViewController.h"

#import "ZJScrollPageView.h"

@interface MineOrdersViewController : BaseTableViewController<ZJScrollPageViewDelegate,ZJScrollPageViewChildVcDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@end
