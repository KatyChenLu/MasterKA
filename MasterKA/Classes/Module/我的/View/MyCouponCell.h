//
//  MyCouponCell.h
//  MasterKA
//
//  Created by hyu on 16/5/3.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponCell : UITableViewCell
-(void)showMyCoupon:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *intro;
@property (weak, nonatomic) IBOutlet UILabel *coupon_name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
