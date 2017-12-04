//
//  KAInVoteTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/22.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAInVoteTableViewCell.h"

@implementation KAInVoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showInVote:(NSDictionary *)dic {
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@发起的投票",dic[@"nikename"]];
    self.contentLabel.text = dic[@"title"];
    self.peopleNum.text = [NSString stringWithFormat:@"%@人",dic[@"course_id"]];
    if ([dic[@"course_id"] isEqualToString: @"3533"]) {
       self.titleLabel.alpha = 0.3;
        self.contentLabel.alpha = 0.3;
        self.peopleNum.alpha = 0.3;
    }
}
@end
