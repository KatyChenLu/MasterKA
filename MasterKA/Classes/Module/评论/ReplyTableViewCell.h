//
//  ReplyTableViewCell.h
//  HiGoMaster
//
//  Created by jinghao on 15/2/5.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ReplyTableViewCell : BaseTableViewCell
@property (nonatomic,weak)IBOutlet UILabel* nickNameLabel;
@property (nonatomic,weak)IBOutlet UILabel* replyContentLabel;
@property (nonatomic,weak)IBOutlet UILabel* timeReplyLabel;
@property (nonatomic,strong)id itemData;
@end
