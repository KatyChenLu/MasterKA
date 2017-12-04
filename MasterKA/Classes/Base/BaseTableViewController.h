//
//  BaseTableViewController.h
//  MasterKA
//
//  Created by jinghao on 16/2/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak, readonly) UITableView *mTableView;
@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;

- (void)reloadData;
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
