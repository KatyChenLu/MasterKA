//
//  MineTableViewCell.m
//  MasterKA
//
//  Created by jinghao on 16/3/1.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MineTableViewCell.h"
#import "MineMenuModel.h"
@implementation MineTableViewCell

- (void)awakeFromNib {
    // Initialization code
   [super awakeFromNib];
    
//    self.iconImageView.frame = CGRectIntegral(self.iconImageView.frame);
    self.titleLabelView.frame = CGRectIntegral(self.titleLabelView.frame);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)bindViewModel:(MineMenuModel*)model{
//    self.iconImageView.image = [UIImage imageNamed:model.icon];
    self.titleLabelView.text = model.title;
}

@end
