//
//  MyCouponCell.m
//  MasterKA
//
//  Created by hyu on 16/5/3.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyCouponCell.h"

@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showMyCoupon:(NSDictionary *)dic{
    self.coupon_name.text=[dic objectForKey:@"coupon_name"];
    self.intro.text=[dic objectForKey:@"intro"];
    self.price.text=[NSString stringWithFormat:@"%ld",[[dic objectForKey:@"price"] integerValue]];
    NSString *start =[self changeTIme:[dic objectForKey:@"start_used_time"]];
    NSString *end =[self changeTIme:[dic objectForKey:@"end_used_time"]];
    self.time.text=[NSString stringWithFormat:@"%@至%@有效",start,end];
}
-(NSString *)changeTIme:(NSString *)str{
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}
@end
