//
//  UITableView+Master.m
//  MasterKA
//
//  Created by jinghao on 15/12/25.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UITableView+Master.h"

@implementation UITableView (Master)

- (void)registerCellWithReuseIdentifier:(NSString *)identifier{
    UINib* nib = [UINib nibWithNibName:identifier bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)clearDefaultStyle{
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}

@end
