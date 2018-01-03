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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVoteBtnChange:) name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVoteBtnChange:) name:@"cancelVote" object:nil];
}
- (void)addVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    if([self.ka_course_id isEqualToString:infoDic[@"ka_course_id"]]){
        self.voteBtn.selected = YES;
        self.voteBtn.borderWidth = 1.0f;
        self.voteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
    }
}
- (void)cancelVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    if([self.ka_course_id isEqualToString:infoDic[@"ka_course_id"]]){
        self.voteBtn.selected = NO;
        self.voteBtn.borderWidth = 0.0f;
        self.voteBtn.borderColor = [UIColor clearColor];
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelVote" object:nil];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showTitleCell:(NSDictionary *)dic {
    self.ka_course_id = dic[@"ka_course_id"];
    self.titleLabel.text = dic[@"course_title"];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.introLabel.text = dic[@"course_sub_title"];
    self.timeLabel.text = dic[@"course_time"];
    self.peopleLabel.text = [NSString stringWithFormat:@"%@人起",dic[@"people_num"]];
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
- (IBAction)voteBtnAction:(id)sender {
    if ([(BaseViewController *)self.superViewController doLogin]) {
        if (self.voteBtn.selected) {
            self.canceljoinClick(self.ka_course_id);
            self.voteBtn.borderWidth = 0.0f;
            self.voteBtn.borderColor = [UIColor clearColor];
            self.voteBtn.selected  = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVote" object:@{@"ka_course_id":self.ka_course_id}];
        }else{
            self.joinClick(self.ka_course_id);
            
            self.voteBtn.borderWidth = 1.0f;
            self.voteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
            self.voteBtn.selected  = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addVote" object:@{@"ka_course_id":self.ka_course_id}];
        }
        
        //        self.voteBtn.selected = !self.voteBtn.selected;
    }
}

@end
