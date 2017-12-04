//
//  UITableView+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/25.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Master)
- (void)registerCellWithReuseIdentifier:(NSString *)identifier;

- (void)clearDefaultStyle;

@end
