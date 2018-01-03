//
//  KADetailVoteTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailVoteTableViewCell.h"
#import "KACustomViewController.h"
#import "YSProgressView.h"

@implementation KADetailVoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showKADetailVoteDetail:(NSDictionary *)dic {
    [UILabel changeSpaceForLabel:self.KAtitleLabel withLineSpace:2 WordSpace:0.2];
    
    self.KAtitleLabel.text = dic[@"course_title"];
      self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.KAPrice.text = dic[@"course_price"];
      self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
//    [self.KAimgV setImageWithURLString:dic[@"course_cover"] placeholderImage:nil];
    [self.KAimgV setImageFadeInWithURLString:[dic[@"course_cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",96*0.75*ScreenScale]] placeholderImage:nil];
    self.KAtime.text = dic[@"course_time"];
    self.KApeopleNum.text = [NSString stringWithFormat:@"%@人起",dic[@"people_num"]];
    self.ka_course_id = dic[@"ka_course_id"];
  
    self.item_id = dic[@"item_id"];
    
    UIView *proBgView = [[UIView alloc] init];
    [self.contentView addSubview:proBgView];
    [proBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.contentView);
        make.top.equalTo(self.KAimgV.mas_bottom).offset(10);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shoeVotePeople)];

    tap.numberOfTapsRequired = 1;
    [proBgView addGestureRecognizer:tap];
    
    UIImageView *youImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiangyou"]];
    [proBgView addSubview:youImgView];
    [youImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(proBgView.mas_right).offset(-17);
        make.width.equalTo(@4);
        make.height.equalTo(@9);
        make.top.equalTo(proBgView.mas_top).offset(2);
    }];
    
    UILabel *toupiaoNumLabel = [[UILabel alloc] init];
    toupiaoNumLabel.text = [NSString stringWithFormat:@"%@人已投票",dic[@"result_num"]];
    toupiaoNumLabel.font = [UIFont systemFontOfSize:10];
    toupiaoNumLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [proBgView addSubview:toupiaoNumLabel];
    [toupiaoNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(ysView.mas_right).offset(10);
        make.right.equalTo(youImgView.mas_left).offset(-5);
        make.height.equalTo(@12);
        make.top.equalTo(proBgView.mas_top);
    }];
    

    
    YSProgressView *ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(12, 118, ScreenWidth - 90, 5)];
    ysView.trackTintColor = MasterDefaultColor;
    ysView.progressTintColor = RGBFromHexadecimal(0xf2f2f2);
    CGFloat progressWidth = (ScreenWidth -90)*[dic[@"percent"] floatValue];
    ysView.progressValue = progressWidth;
    [proBgView addSubview:ysView];
    [ysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(proBgView.mas_left).offset(12);
        make.right.equalTo(toupiaoNumLabel.mas_left).offset(-5);
        make.height.equalTo(@6);
        make.top.equalTo(proBgView.mas_top).offset(2);
    }];
   

    
}
- (IBAction)dingzhiAction:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"KA" bundle:[NSBundle mainBundle]];
    KACustomViewController *myView = [story instantiateViewControllerWithIdentifier:@"KACustomViewController"];
    myView.courseID = self.ka_course_id;
    myView.courseTitle = self.KAtitleLabel.text;
    [self.superViewController.navigationController pushViewController:myView animated:YES];
}
- (void)shoeVotePeople {
    self.showVotePeople(self.item_id,self.KAtitleLabel.text);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
