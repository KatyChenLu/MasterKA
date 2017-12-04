//
//  CommentTableViewCell.h
//  HiGoMaster
//
//  Created by jinghao on 15/2/5.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"
@class CommentTableViewCell;
@protocol CommentTableViewCellDelegate <NSObject>

@required
- (void)commentTableViewCell:(CommentTableViewCell*)cell replyInfo:(id)replyInfo;
- (void)commentTableViewCellHeadView:(CommentTableViewCell*)cell itemData:(id)itemData;

@end

@interface CommentTableViewCell : BaseTableViewCell

@property (nonatomic,weak)IBOutlet UIImageView* headImageView;
@property (nonatomic,weak)IBOutlet UILabel* nickNameView;
@property (nonatomic,weak)IBOutlet UILabel* floorView;
@property (nonatomic,weak)IBOutlet UILabel* commentContentView;
@property (nonatomic,weak)IBOutlet UILabel* timeView;
@property (nonatomic,weak)IBOutlet UIView* replyLayoutView;
@property (nonatomic,strong)id itemData;
@property (nonatomic,strong)id<CommentTableViewCellDelegate> delegate;

- (void)setItemData:(id)data;
@end
