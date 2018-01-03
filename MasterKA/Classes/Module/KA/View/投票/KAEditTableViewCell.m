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
     self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
     self.KAPrice.text = [NSString stringWithFormat:@"￥%@",dic[@"course_price"]];
    self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
//    [self.KAimgV setImageWithURLString:dic[@"course_cover"] placeholderImage:nil];
    [self.KAimgV setImageFadeInWithURLString:[dic[@"course_cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",96*0.75*ScreenScale]] placeholderImage:nil];
    self.KAtime.text = dic[@"course_time"];
    self.KApeopleNum.text = [NSString stringWithFormat:@"%@人起",dic[@"people_num"]];
    self.ka_course_id = dic[@"ka_course_id"];
    self.is_del = dic[@"is_del"];
    self.status = dic[@"status"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
