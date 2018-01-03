//
//  KAInVoteTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/22.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAInVoteTableViewCell.h"
#import "NSString+MasterTime.h"

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
    self.vote_id = dic[@"vote_id"];
    self.uid = dic[@"uid"];
    self.titleLabel.text = dic[@"vote_title"];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f];
    self.contentLabel.text = dic[@"vote_desc"];
    NSString *endStr = dic[@"end_text"];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:endStr];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:NSMakeRange(7, endStr.length - 7)];
    self.timeLabel.attributedText = attrStr;
    
    self.endTime.text = [NSString stringWithFormat:@"发起时间: %@",[NSString timestampSwitchTime:[dic[@"end_time"] doubleValue] andFormatter:@"YYYY-MM-dd"]];
    self.peopleNum.text = [NSString stringWithFormat:@"%@人",dic[@"vote_count"]];
    if ([dic[@"is_end"] isEqualToString:@"1"]) {
        self.contentView.alpha = 0.3;
        self.endImgV.hidden = NO;
    }else{
        self.contentView.alpha = 1.0;
        self.endImgV.hidden = YES;
    }
}
@end
