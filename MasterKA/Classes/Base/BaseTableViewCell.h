//
//  BaseTableViewCell.h
//  MasterKA
//
//  Created by jinghao on 15/12/24.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterReactiveView.h"
@interface BaseTableViewCell : UITableViewCell<MasterReactiveView>
@property (nonatomic,assign)BOOL showCustomLineView;
@property (nonatomic,assign)BOOL showTopLineView;
@property (nonatomic,strong,readonly)UIView *lineView;
- (UITableView *)tableView;
@end
