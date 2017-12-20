//
//  KAEditTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/8.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAEditTableViewCell.h"

@implementation KAEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showKAPreVoteDetail:(NSDictionary *)dic {
    [UILabel changeSpaceForLabel:self.KAtitleLabel withLineSpace:2 WordSpace:0.2];
    
    self.KAtitleLabel.text = dic[@"course_title"];
    self.KAPrice.text = dic[@"course_price"];
    [self.KAimgV setImageWithURLString:dic[@"course_cover"] placeholderImage:nil];
    self.KAtime.text = dic[@"course_time"];
    self.KApeopleNum.text = dic[@"people_num"];
    self.ka_course_id = dic[@"ka_course_id"];
    self.is_del = dic[@"is_del"];
    self.status = dic[@"status"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
