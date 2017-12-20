//
//  KAVotePeopleTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAVotePeopleTableViewCell.h"

@implementation KAVotePeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showVotePeople:(NSDictionary *)dic {
    self.timeLabel.text = dic[@"add_time"];
    self.votePeopleLabel.text = dic[@"nikename"];
    [self.votePeopleImgView setImageWithURLString:dic[@"img_top"] placeholderImage:nil];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
