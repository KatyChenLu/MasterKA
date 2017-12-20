//
//  KADingzhiTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/8.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADingzhiTableViewCell.h"

@implementation KADingzhiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showDingzhiDetail:(NSDictionary *)dic {
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
