//
//  MyOrderInforMationController.h
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface MyOrderDetailController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *refuseOrder;
@property (nonatomic,strong) NSString* isfromCode;
@end
