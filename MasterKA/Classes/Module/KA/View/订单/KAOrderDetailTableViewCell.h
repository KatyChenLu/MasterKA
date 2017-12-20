//
//  KAOrderDetailTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/28.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KAOrderDetailTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *lineImgV;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)showOrderDetail:(NSDictionary *)dic;
@end
