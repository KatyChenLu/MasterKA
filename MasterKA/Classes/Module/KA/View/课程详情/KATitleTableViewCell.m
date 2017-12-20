//
//  KATitleTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KATitleTableViewCell.h"

@implementation KATitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likeBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)showTitleCell:(NSDictionary *)dic {
    self.ka_course_id = dic[@"ka_course_id"];
    self.titleLabel.text = dic[@"course_title"];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.introLabel.text = dic[@"course_sub_title"];
    self.timeLabel.text = dic[@"course_time"];
    self.peopleLabel.text = dic[@"people_num"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"course_price"]];
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    if ([dic[@"is_vote_cart"] isEqualToString:@"0"]) {
        self.voteBtn.selected = NO;
        
        self.voteBtn.borderWidth = 0.0f;
        self.voteBtn.borderColor = [UIColor clearColor];
    }else{
        self.voteBtn.selected = YES;
        
        self.voteBtn.borderWidth = 1.0f;
        self.voteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
    }
    
    [self.voteBtn setBackgroundImage:[UIImage imageWithColor:MasterDefaultColor] forState:UIControlStateSelected];
    [self.voteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.voteBtn setTitle:@"加入投票" forState:UIControlStateNormal];
    
    [self.voteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [self.voteBtn setTitleColor:RGBFromHexadecimal(0xb9b8af) forState:UIControlStateSelected];
    [self.voteBtn setTitle:@"取消投票" forState:UIControlStateSelected];
    
}
- (IBAction)voteAction:(id)sender {
    if (self.voteBtn.selected) {
        self.canceljoinClick(self.ka_course_id);
        
        self.voteBtn.borderWidth = 0.0f;
        self.voteBtn.borderColor = [UIColor clearColor];
        
    }else{
        self.joinClick(self.ka_course_id);
        
        self.voteBtn.borderWidth = 1.0f;
        self.voteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
    }
    
    self.voteBtn.selected = !self.voteBtn.selected;
}
@end
