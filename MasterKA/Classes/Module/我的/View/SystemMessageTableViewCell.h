//
//  SystemMessageTableViewCell.h
//  HiGoMaster
//
//  Created by jinghao on 15/6/16.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SystemMessageTableViewCell : BaseTableViewCell
@property (nonatomic,weak)IBOutlet NSLayoutConstraint*  moreLayoutHeight;
@property (nonatomic,strong)id itemData;
@end
