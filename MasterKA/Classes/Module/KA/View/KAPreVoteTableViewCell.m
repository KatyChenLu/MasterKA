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

- (void)showKAPreVoteDetail:(NSDictionary *)dic {
    [UILabel changeSpaceForLabel:self.KAtitleLabel withLineSpace:2 WordSpace:0.2];
    self.KApreVoteBtn.selected = YES;
    self.KAtitleLabel.text = dic[@"title"];
    self.KAPrice.text = dic[@"price"];
    [self.KAimgV setImageWithURLString:dic[@"cover"] placeholderImage:nil];
    if (self.imvBotton.constant ==32) {
        NSLog(@"1#######################");
        YSProgressView *ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(12, 116, ScreenWidth - 75, 10)];
        ysView.trackTintColor = MasterDefaultColor;
        ysView.progressTintColor = RGBFromHexadecimal(0xf2f2f2);
        [self.contentView addSubview:ysView];
         CGFloat progressWidth = 960/10.f;
        ysView.progressValue = progressWidth;
        
        UILabel *toupiaoNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(ysView.right +10, 116, 70, 10)];
        toupiaoNumLabel.text = @"4人已投票";
        toupiaoNumLabel.font = [UIFont systemFontOfSize:10];
        toupiaoNumLabel.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self.contentView addSubview:toupiaoNumLabel];
    }else if (self.imvBotton.constant ==74){
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
- (IBAction)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.selectClick(@"1");
    }else{
        self.disselectClick(@"1");
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
