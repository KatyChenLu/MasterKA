//
//  MyOrderCell.h
//  MasterKA
//
//  Created by hyu on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *evaluate;
@property (weak, nonatomic) IBOutlet UIButton *check;
@property (weak, nonatomic) IBOutlet UIButton *deleteOrder;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *moneyBefore;
@property (weak, nonatomic) IBOutlet UILabel *moneyAfter;
@property (weak, nonatomic) IBOutlet UIImageView *classImg;
-(void)showOrder:(NSDictionary *)info with:(NSString*)identifier;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cheak_eva;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *check_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linetobottom;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showLabelHeight;
@property (weak, nonatomic) IBOutlet UIButton *userInfo;
@property (nonatomic,strong)NSDictionary *order;
@property (nonatomic,strong)RACCommand *userInfoRAC;
@end
