//
//  FirstLevelTableView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "FirstLevelTableView.h"
#import "categoryFilterCell.h"


@interface FirstLevelTableView ()<UITableViewDataSource , UITableViewDelegate>

@end

@implementation FirstLevelTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableFooterView = [UIView new];
        
        [self registerNib:[UINib nibWithNibName:@"categoryFilterCell" bundle:nil] forCellReuseIdentifier:@"categoryFilterCell"];
    }
    return self;
}



@end
