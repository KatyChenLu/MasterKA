//
//  NameAndMoneyCell.m
//  MasterKA
//
//  Created by hyu on 16/5/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "NameAndMoneyCell.h"

@implementation NameAndMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showMoneyAndname:(NSDictionary *)dic{
    self.discountLabel.text=@"";
    self.title.text=dic[@"title"];
    if([dic[@"is_mpay"] isEqual:@"1"]){
        self.price.text=[NSString stringWithFormat:@"%@ M点",dic[@"m_price"]];
        self.discountLabel.text=@"M点体验课";
    }else{
        self.price.text = [NSString stringWithFormat:@"%@%@",[dic[@"price"] isEqualToString:@"底部联系我们了解更多"]?@"":@"¥",dic[@"price"]];
    }
    if (dic[@"coupon"] ||[self.discountLabel.text  isEqualToString:@"M点体验课"]) {
        self.discountLabel.text =dic[@"coupon"]?dic[@"coupon"]:@"M点体验课";
        self.discountImg.hidden=NO;
        self.discountLabel.hidden=NO;
        self.toBottom.priority=750;
        self.noCouponToBottom.priority=250;
    
    }else{
        self.discountLabel.text =@"";
        self.discountImg.hidden=YES;
        self.discountLabel.hidden=YES;
        self.toBottom.priority=250;
        self.noCouponToBottom.priority=750;
    }


}
@end
