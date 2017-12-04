//
//  MyFansViewController.h
//  MasterKA
//
//  Created by hyu on 16/4/28.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface MyFansViewController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property(nonatomic, copy)NSString * index_article_id;

@end
