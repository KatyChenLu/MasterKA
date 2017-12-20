//
//  KAPlaceDetailTitleTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/30.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceDetailTitleTableViewCell.h"

@implementation KAPlaceDetailTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configueCellWithModel:(NSDictionary * )dic{
    self.titleLabel.text = dic[@"content"];
    self.titleBottom.constant = [dic[@"bottom"] floatValue]/2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
