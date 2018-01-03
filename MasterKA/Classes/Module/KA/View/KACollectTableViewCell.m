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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVoteBtnChange:) name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVoteBtnChange:) name:@"cancelVote" object:nil];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelVote" object:nil];
}
- (void)addVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    if([self.ka_course_id isEqualToString:infoDic[@"ka_course_id"]]){
        [_collectDic setValue:@"1" forKey:@"is_vote_cart"];
        self.addVoteBtn.selected = YES;
        self.addVoteBtn.borderWidth = 1.0f;
        self.addVoteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
    }
}
- (void)cancelVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    if([self.ka_course_id isEqualToString:infoDic[@"ka_course_id"]]){
        [_collectDic setValue:@"0" forKey:@"is_vote_cart"];
        self.addVoteBtn.selected = NO;
        self.addVoteBtn.borderWidth = 0.0f;
        self.addVoteBtn.borderColor = [UIColor clearColor];
    }
}
- (void)setCollectDic:(NSDictionary *)collectDic {
    _collectDic = collectDic;
    self.KAtitleLabel.text = _collectDic[@"course_title"];
     self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.KAPrice.text = _collectDic[@"course_price"];
     self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
//    [self.KAimgV setImageWithURLString:_collectDic[@"course_cover"] placeholderImage:nil];
    [self.KAimgV setImageFadeInWithURLString:[_collectDic[@"course_cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",96*0.75*ScreenScale]] placeholderImage:nil];
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
        self.addVoteBtn.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVote" object:@{@"ka_course_id":self.ka_course_id}];
    }else{
        self.joinClick(self.KAimgV,self.ka_course_id);
        [_collectDic setValue:@"1" forKey:@"is_vote_cart"];
        
        self.addVoteBtn.borderWidth = 1.0f;
        self.addVoteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
        self.addVoteBtn.selected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addVote" object:@{@"ka_course_id":self.ka_course_id}];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
