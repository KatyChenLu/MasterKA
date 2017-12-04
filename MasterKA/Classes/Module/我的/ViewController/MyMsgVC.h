//
//  MyMsgVC.h
//  MasterKA
//
//  Created by xmy on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface MyMsgVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSMutableArray  *dataSource;


@end
