//
//  OrderDetailCell.h
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UILabel *nikeName;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *classTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonBorder;
@property (weak, nonatomic) IBOutlet UIButton *kefuButton;
@property (weak, nonatomic) IBOutlet UIImageView *commitOrder;
@property (weak, nonatomic) IBOutlet UILabel *commitLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *lineAfter;
@property (weak, nonatomic) IBOutlet UIImageView *wait;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startClass;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) NSDictionary *detail;
-(void)prepareView :(NSDictionary *)orderInfo;
@property (weak, nonatomic) IBOutlet UIButton *userInfo;
@property (nonatomic,strong)RACCommand *userInfoRAC;
@property (weak, nonatomic) IBOutlet UIButton *courseInfo;
@property (nonatomic,strong)RACCommand *courseInfoRAC;
@end
