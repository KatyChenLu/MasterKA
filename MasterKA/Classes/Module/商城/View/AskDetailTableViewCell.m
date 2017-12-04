//
//  AskDetailTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AskDetailTableViewCell.h"

@implementation AskDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showAskDetailList:(NSDictionary *)dic {
    
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = self.headImgView.height/2;
    [_headImgView setImageWithURLString:dic[@"img_top"] placeholderImage:nil];
    _nameLabel.text = dic[@"nikename"];
    _timeLabel.text = dic[@"answer_time"];
    _contentLabel.text = dic[@"answer_content"];
    
}
@end
