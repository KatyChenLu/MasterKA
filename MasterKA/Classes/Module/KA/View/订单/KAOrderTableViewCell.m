//
//  KAOrderTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/20.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrderTableViewCell.h"
#import "YSProgressView.h"
#define PROGRESS_W 220

@implementation KAOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)showKAOrder:(NSDictionary *)dic {
    self.oid = dic[@"oid"];
    self.orderStatus = dic[@"order_status"];
    self.KAtitleLabel.text = dic[@"course_title"];
    self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f];
    [self.KAimgV setImageWithURLString:dic[@"course_cover"] placeholderImage:nil];
     self.KAPrice.text = dic[@"course_price"];
     self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18.0f];
    self.KAtime.text = dic[@"course_time"];
    self.statueImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderStatus%@",self.orderStatus]];
    if ([self.orderStatus integerValue] <= 1) {
        self.peopleNumImgView.hidden = NO;
        self.dizhiImgView.hidden = YES;
        self.yijianImgView.hidden = YES;
        self.tongzhiBtn.hidden = YES;
        self.qiLabel.text = @"起";
        self.KApeopleNum.text = [NSString stringWithFormat:@"%@人起",dic[@"people_num"]];
    }else {
        self.peopleNumImgView.hidden = YES;
        self.dizhiImgView.hidden = NO;
        self.qiLabel.text = @"总价";
        self.KApeopleNum.text = dic[@"address"];
        if ([self.orderStatus integerValue] == 2) {
            self.yijianImgView.hidden = NO;
            self.tongzhiBtn.hidden = NO;
        }else{
            self.yijianImgView.hidden = YES;
            self.tongzhiBtn.hidden = YES;
        }
    }
    if ([self.orderStatus isEqualToString:@"0"]) {
        self.yizhongzhiImgView.hidden = NO;
        self.contentView.alpha = 0.5f;
    }else{
        self.yizhongzhiImgView.hidden = YES;
          self.contentView.alpha = 1.0f;
    }
//    YSProgressView *ysView = [[YSProgressView alloc] initWithFrame:CGRectMake(12, 130, PROGRESS_W, 1)];
//    ysView.trackTintColor = MasterDefaultColor;
//    ysView.progressTintColor = RGBFromHexadecimal(0xf2f2f2);
//    ysView.progressHeight = 1;
//    [self.contentView addSubview:ysView];
//
//    NSArray *arr = @[@"KA已提交",@"KA已预定",@"KA已执行",@"KA已开票",@"KA已支付"];
//     NSArray *noArr = @[@"KA已提交",@"KA未预定",@"KA未执行",@"KA未开票",@"KA未支付"];
//
//    NSMutableArray *finalArr = [NSMutableArray arrayWithArray:[arr subarrayWithRange:NSMakeRange(0, [self.orderStatus integerValue])]];
//    [finalArr addObjectsFromArray:[noArr subarrayWithRange:NSMakeRange([self.orderStatus integerValue], 4-[self.orderStatus integerValue]+1)]];
//
//    UIView *baseView =[[UIView alloc] initWithFrame:CGRectMake(12, 130, PROGRESS_W, 1)];
//    baseView.backgroundColor = [UIColor clearColor];
//    for (int i =0; i<5; i++) {
//        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:finalArr[i]]];
//        imgV.frame = CGRectMake(0, 0, 20, 20);
//        imgV.center = CGPointMake(PROGRESS_W/4*i, 0.5);
//        [baseView addSubview:imgV];
//
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 50, 15)];
//        lbl.center = CGPointMake(PROGRESS_W/4*i, 30);
//        lbl.text = finalArr[i];
//        lbl.font = [UIFont systemFontOfSize:12];
//        [lbl sizeToFit];
//        lbl.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
//        [baseView addSubview:lbl];
//    }
//    [self.contentView addSubview:baseView];
//    CGFloat progressWidth = PROGRESS_W*[self.orderStatus integerValue]/4;
//    ysView.progressValue = progressWidth;
//
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
