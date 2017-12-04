//
//  CouseDetailCell.m
//  MasterKA
//
//  Created by hyu on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CouseDetailCell.h"

@implementation CouseDetailCell
#define IMGVIEW_WIDTH ([UIScreen mainScreen].bounds.size.width/9.4)
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.name.frame = CGRectIntegral(self.name.frame);
    self.brief.frame = CGRectIntegral(self.brief.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCourseDetail:(id)detail{
    if(detail[@"coupon_id"]){
        [self.cardOrCoupon setImage:[UIImage imageNamed:@"quan"]];
        self.name.text=detail[@"coupon_name"];
        self.brief.text=detail[@"coupon_brief"];
    }else{
        [self.cardOrCoupon setImage:[UIImage imageNamed:@"ka"]];
        self.name.text=detail[@"card_name"];
        self.brief.text=detail[@"card_brief"];
    }
}

@end
