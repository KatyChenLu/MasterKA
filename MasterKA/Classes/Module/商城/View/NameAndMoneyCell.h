//
//  NameAndMoneyCell.h
//  MasterKA
//
//  Created by hyu on 16/5/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameAndMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *discountImg;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
-(void) showMoneyAndname :(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noCouponToBottom;

@end
