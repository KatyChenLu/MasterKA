//
//  KAOrderTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/20.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrderTableViewCell.h"
#import "YSProgressView.h"
#import "KAOrderShareViewController.h"
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
    self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [self.KAimgV setImageWithURLString:dic[@"course_cover"] placeholderImage:nil];

     self.KAPrice.text = dic[@"course_price"];
     self.KAPrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.qiLabel.text = dic[@"course_price_ext"];
    
    self.KAtime.text = dic[@"course_time"];
    self.statueImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderStatus%@",self.orderStatus]];
    if ([self.orderStatus integerValue] <= 1) {
        self.peopleNumImgView.hidden = NO;
        self.dizhiImgView.hidden = YES;
        self.yijianImgView.hidden = YES;
        self.tongzhiBtn.hidden = YES;
        
        self.KApeopleNum.text = dic[@"people_num"];
        
    }else {
        self.peopleNumImgView.hidden = YES;
        self.dizhiImgView.hidden = NO;
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
    
//    if (!self.KAPrice.text.length) {
//        self.KAPrice.hidden = YES;
//    }else{
//        self.KAPrice.hidden = NO;
//    }
  
    
}
- (IBAction)tongzhiAction:(id)sender {
//    KAOrderShareViewController *shareOrderVC = [KAOrderShareViewController ]
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"KA" bundle:[NSBundle mainBundle]];
    KAOrderShareViewController *myView = [story instantiateViewControllerWithIdentifier:@"KAOrderShareViewController"];
    myView.oid = self.oid;
    myView.orderStatus = self.orderStatus;
    [self.tableView.superViewController pushViewController:myView animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
