//
//  KADetailVoteTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KADetailVoteTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *KAtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *KAimgV;
@property (weak, nonatomic) IBOutlet UILabel *KAtime;
@property (weak, nonatomic) IBOutlet UILabel *KApeopleNum;
@property (weak, nonatomic) IBOutlet UILabel *KAPrice;
//投票项id
@property (nonatomic, strong)NSString *item_id;
//投票数
@property (nonatomic, strong)NSString *result_num;
//团建课程id
@property (nonatomic, strong)NSString *ka_course_id;
//投票百分比
@property (nonatomic, strong)NSString *percent;

@property (nonatomic, copy) void(^showVotePeople)(NSString *itemId,NSString *peoTitle);
- (void)showKADetailVoteDetail:(NSDictionary *)dic;
@end
