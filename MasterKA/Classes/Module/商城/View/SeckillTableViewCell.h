//
//  SeckillTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/4/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCountDownView.h"

@interface SeckillTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seckillLabel;
@property (weak, nonatomic) IBOutlet UILabel *seckillPrice;
@property (weak, nonatomic) IBOutlet CLCountDownView *countDownView;
@property (weak, nonatomic) IBOutlet UILabel *miaoShaJiaLabel;
@property(nonatomic ,copy)void(^seckillEnd)();

-(void)showSeckillDetail:(NSDictionary *)detail;
@end
