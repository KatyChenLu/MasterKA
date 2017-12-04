//
//  PaySuccessTableView.m
//  MasterKA
//
//  Created by 余伟 on 16/8/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "PaySuccessTableView.h"

@implementation PaySuccessTableView


+(PaySuccessTableView*)PaySuccessTableViewWithFrame:(CGRect)frame
{

    
    CGRect current = frame;
    
    current.size.height = frame.size.height-64;
    
    frame = current;
    
    PaySuccessTableView * tableView = [[PaySuccessTableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    
    return tableView;
}






@end
