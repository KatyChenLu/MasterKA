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

@implementation KAPreVoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setKaProVoteDic:(NSDictionary *)dic {
    _kaProVoteDic = dic;
    [UILabel changeSpaceForLabel:self.KAtitleLabel withLineSpace:2 WordSpace:0.2];
    self.KApreVoteBtn.selected = _kaProVoteDic[@"isSelect"];
    self.KAtitleLabel.text = _kaProVoteDic[@"course_title"];
    self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f];
    self.KAPrice.text = [NSString stringWithFormat:@"￥%@",_kaProVoteDic[@"course_price"]];
    self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18.0f];
    [self.KAimgV setImageWithURLString:_kaProVoteDic[@"course_cover"] placeholderImage:nil];
    self.KAtime.text = _kaProVoteDic[@"course_time"];
    self.KApeopleNum.text = [NSString stringWithFormat:@"%@人起",_kaProVoteDic[@"people_num"]];
    self.ka_course_id = _kaProVoteDic[@"ka_course_id"];
    self.is_del = _kaProVoteDic[@"is_del"];
    self.status = _kaProVoteDic[@"status"];
    
    
    self.KAtitleLabel.userInteractionEnabled = YES;
      self.KApreVoteBtn.userInteractionEnabled = YES;
      self.KAPrice.userInteractionEnabled = YES;
    self.KAimgV.userInteractionEnabled = YES;
      self.KApeopleNum.userInteractionEnabled = YES;
      self.qiLabel.userInteractionEnabled = YES;
    
    
    
    if (self.imvBotton.constant ==74){
        NSLog(@"2#######################");
        YSProgressView *ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(30, 130, ScreenWidth - 75, 1)];
        ysView.trackTintColor = MasterDefaultColor;
        ysView.progressTintColor = RGBFromHexadecimal(0xf2f2f2);
        ysView.progressHeight = 1;
        [self.contentView addSubview:ysView];
        
        NSArray *arr = @[@"KA已确认",@"KA未确认",@"KA已执行",@"KA已确认"];
        
        UIView *baseView =[[UIView alloc] initWithFrame:CGRectMake(30, 130, ScreenWidth - 75, 1)];
        baseView.backgroundColor = [UIColor clearColor];
        for (int i =0; i<4; i++) {
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arr[i]]];
            imgV.frame = CGRectMake(0, 0, 20, 20);
            imgV.center = CGPointMake((ScreenWidth - 75)/3*i, 0.5);
            [baseView addSubview:imgV];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 50, 15)];
            lbl.center = CGPointMake((ScreenWidth - 75)/3*i, 30);
            lbl.text = arr[i];
            lbl.font = [UIFont systemFontOfSize:12];
            [lbl sizeToFit];
            lbl.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            [baseView addSubview:lbl];
        }
        [self.contentView addSubview:baseView];
        CGFloat progressWidth = 960/10.f;
        ysView.progressValue = progressWidth;
    }
}

//- (void)showKAPreVoteDetail:(NSDictionary *)dic {
//    [UILabel changeSpaceForLabel:self.KAtitleLabel withLineSpace:2 WordSpace:0.2];
//    self.KApreVoteBtn.selected = YES;
//    self.KAtitleLabel.text = dic[@"course_title"];
//    self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f];
//    self.KAPrice.text = [NSString stringWithFormat:@"￥%@",dic[@"course_price"]];
//    self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18.0f];
//    [self.KAimgV setImageWithURLString:dic[@"course_cover"] placeholderImage:nil];
//    self.KAtime.text = dic[@"course_time"];
//    self.KApeopleNum.text = [NSString stringWithFormat:@"%@人起",dic[@"people_num"]];
//    self.ka_course_id = dic[@"ka_course_id"];
//    self.is_del = dic[@"is_del"];
//    self.status = dic[@"status"];
//
//   if (self.imvBotton.constant ==74){
//        NSLog(@"2#######################");
//        YSProgressView *ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(30, 130, ScreenWidth - 75, 1)];
//        ysView.trackTintColor = MasterDefaultColor;
//        ysView.progressTintColor = RGBFromHexadecimal(0xf2f2f2);
//        ysView.progressHeight = 1;
//        [self.contentView addSubview:ysView];
//
//        NSArray *arr = @[@"KA已确认",@"KA未确认",@"KA已执行",@"KA已确认"];
//
//        UIView *baseView =[[UIView alloc] initWithFrame:CGRectMake(30, 130, ScreenWidth - 75, 1)];
//        baseView.backgroundColor = [UIColor clearColor];
//        for (int i =0; i<4; i++) {
//            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arr[i]]];
//            imgV.frame = CGRectMake(0, 0, 20, 20);
//            imgV.center = CGPointMake((ScreenWidth - 75)/3*i, 0.5);
//            [baseView addSubview:imgV];
//
//            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 50, 15)];
//            lbl.center = CGPointMake((ScreenWidth - 75)/3*i, 30);
//            lbl.text = arr[i];
//            lbl.font = [UIFont systemFontOfSize:12];
//            [lbl sizeToFit];
//            lbl.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//            [baseView addSubview:lbl];
//        }
//        [self.contentView addSubview:baseView];
//        CGFloat progressWidth = 960/10.f;
//        ysView.progressValue = progressWidth;
//    }
//}
- (IBAction)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.selectClick(self.ka_course_id);
        [_kaProVoteDic setValue:@"0" forKey:@"isSelect"];
    }else{
        self.disselectClick(self.ka_course_id);
         [_kaProVoteDic setValue:@"1" forKey:@"isSelect"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
