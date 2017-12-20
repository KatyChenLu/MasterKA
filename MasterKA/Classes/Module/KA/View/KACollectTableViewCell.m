//
//  KACollectTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KACollectTableViewCell.h"

@implementation KACollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCollectDic:(NSDictionary *)collectDic {
    _collectDic = collectDic;
    self.KAtitleLabel.text = _collectDic[@"course_title"];
    self.KAPrice.text = _collectDic[@"course_price"];
    [self.KAimgV setImageWithURLString:_collectDic[@"course_cover"] placeholderImage:nil];
    self.KAtime.text = _collectDic[@"course_time"];
    self.KApeopleNum.text = _collectDic[@"people_num"];
    self.ka_course_id = _collectDic[@"ka_course_id"];
    
    [self.addVoteBtn setBackgroundImage:[UIImage imageWithColor:MasterDefaultColor] forState:UIControlStateSelected];
    [self.addVoteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addVoteBtn setTitle:@"加入投票" forState:UIControlStateNormal];
    
    [self.addVoteBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [self.addVoteBtn setTitleColor:RGBFromHexadecimal(0xb9b8af) forState:UIControlStateSelected];
    [self.addVoteBtn setTitle:@"取消投票" forState:UIControlStateSelected];
    self.addVoteBtn.borderWidth = 1.0f;
    self.addVoteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);

    
    if ([_collectDic[@"is_vote_cart"] isEqualToString:@"0"]) {
        self.addVoteBtn.selected = NO;
        self.addVoteBtn.borderWidth = 0.0f;
        self.addVoteBtn.borderColor = [UIColor clearColor];
    }else{
        self.addVoteBtn.selected = YES;
        self.addVoteBtn.borderWidth = 1.0f;
        self.addVoteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
    }
    
}

- (IBAction)addVoteAction:(id)sender {
    if (self.addVoteBtn.selected) {
        self.canceljoinClick(self.ka_course_id);
        [_collectDic setValue:@"0" forKey:@"is_vote_cart"];
        self.addVoteBtn.borderWidth = 0.0f;
        self.addVoteBtn.borderColor = [UIColor clearColor];
    }else{
        self.joinClick(self.KAimgV,self.ka_course_id);
        [_collectDic setValue:@"1" forKey:@"is_vote_cart"];
        
        self.addVoteBtn.borderWidth = 1.0f;
        self.addVoteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
    }
    
    self.addVoteBtn.selected = !self.addVoteBtn.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
