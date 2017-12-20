//
//  KAInVoteTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/22.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KAInVoteTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isTouPiao;
@property (weak, nonatomic) IBOutlet UILabel *peopleNum;
@property (weak, nonatomic) IBOutlet UIImageView *endImgV;
@property (nonatomic, strong)NSString *vote_id;
@property (nonatomic, strong)NSString *uid;
- (void)showInVote:(NSDictionary *)dic;
@end
