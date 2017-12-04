//
//  MyMessageTableViewCell.h
//  HiGoMaster
//
//  Created by jinghao on 15/6/8.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MyMessageTableViewCell : BaseTableViewCell
@property (nonatomic,strong)id itemData;
@property (nonatomic,strong)id itemDataComment;
@property (nonatomic,weak)IBOutlet UIView* badgeView;
@end
