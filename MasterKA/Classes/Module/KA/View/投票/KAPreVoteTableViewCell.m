//
//  KAPreVoteTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPreVoteTableViewCell.h"
#import "UILabel+Master.h"
#import "YSProgressView.h"
#import "UIButton+EnlargeTouchArea.h"
#import "KADetailViewController.h"

@implementation KAPreVoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setKaProVoteDic:(NSDictionary *)dic {
    _kaProVoteDic = dic;
    [UILabel changeSpaceForLabel:self.KAtitleLabel withLineSpace:2 WordSpace:0.2];
    self.KApreVoteBtn.selected = [_kaProVoteDic[@"isSelect"] integerValue];
    
    self.isVoteImg.image = [UIImage imageNamed:[_kaProVoteDic[@"isSelect"] integerValue]?@"选择":@"未选择"];
    
    
    
    self.KAtitleLabel.text = _kaProVoteDic[@"course_title"];
    self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.KAPrice.text = [NSString stringWithFormat:@"￥%@",_kaProVoteDic[@"course_price"]];
    self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    
    [self.KAimgV setImageFadeInWithURLString:[_kaProVoteDic[@"course_cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",96*0.75*ScreenScale]] placeholderImage:nil];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    
    [self.KAimgV addGestureRecognizer:singleTapGestureRecognizer];
    
    
    
    self.KAtime.text = _kaProVoteDic[@"course_time"];
    self.KApeopleNum.text = [NSString stringWithFormat:@"%@人起",_kaProVoteDic[@"people_num"]];
    self.ka_course_id = _kaProVoteDic[@"ka_course_id"];
    self.is_del = _kaProVoteDic[@"is_del"];
    self.status = _kaProVoteDic[@"status"];
    
    
    self.KAtitleLabel.userInteractionEnabled = YES;
      self.isVoteImg.userInteractionEnabled = YES;
      self.KAPrice.userInteractionEnabled = YES;
    self.KAimgV.userInteractionEnabled = YES;
      self.KApeopleNum.userInteractionEnabled = YES;
      self.qiLabel.userInteractionEnabled = YES;
    
//    [self.KApreVoteBtn setEnlargeEdgeWithTop:50 right:50 bottom:50 left:300];
    
}
//- (IBAction)btnAction:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    if (sender.isSelected) {
//        self.selectClick(self.ka_course_id);
//        [_kaProVoteDic setValue:@"0" forKey:@"isSelect"];
//    }else{
//        self.disselectClick(self.ka_course_id);
//         [_kaProVoteDic setValue:@"1" forKey:@"isSelect"];
//    }
//    
//}
- (void)singleTap {
    
            KADetailViewController *kaDetailVC = [[KADetailViewController alloc] init];
    
            kaDetailVC.ka_course_id = self.ka_course_id;
            kaDetailVC.headViewUrl = _kaProVoteDic[@"course_cover"];
    
            [self.superViewController pushViewController:kaDetailVC animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
