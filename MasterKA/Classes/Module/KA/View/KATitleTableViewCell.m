//
//  KATitleTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KATitleTableViewCell.h"

@implementation KATitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likeBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (void)showTitleCell:(NSDictionary *)dic {
    self.titleLabel.text = dic[@"title"];
    self.introLabel.text = dic[@"title"];
}
@end
