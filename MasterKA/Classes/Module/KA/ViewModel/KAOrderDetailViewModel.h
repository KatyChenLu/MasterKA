//
//  KAOrderDetailViewModel.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/28.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "TableViewModel.h"

@interface KAOrderDetailViewModel : TableViewModel
@property (nonatomic, strong)NSString *oid;
@property (nonatomic, strong)NSString *orderStatus;
@property (nonatomic, strong)NSDictionary *info;
+ (void)moveAnimationWithTableView:(UITableView *)tableView;
@end
