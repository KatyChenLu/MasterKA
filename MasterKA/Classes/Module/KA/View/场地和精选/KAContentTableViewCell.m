//
//  KAContentTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/29.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAContentTableViewCell.h"


@implementation KAContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configueCellWithModel:(NSDictionary * )dic{
    
    self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.contentLabel.text = dic[@"content"];
    
    [UILabel changeSpaceForLabel:self.contentLabel withLineSpace:5.0 WordSpace:0.7];
    
    self.contentLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    self.contentBottom.constant = [dic[@"bottom"] floatValue]/2;
    
   
}

@end
