//
//  KADetailTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailTableViewCell.h"

@implementation KADetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)showDetail:(NSDictionary *)dic {
    if ([dic[@"type"] isEqualToString:@"cousre_desc"]) {
        self.titleLabel.text = @"课程介绍";
        self.contentLabel.text = dic[@"cousre_desc"];
    }else if ([dic[@"type"] isEqualToString:@"course_product"]) {
        self.titleLabel.text = @"产品内容";
        self.contentLabel.text = dic[@"course_product"];
    }else if ([dic[@"type"] isEqualToString:@"course_content"]) {
        self.titleLabel.text = @"活动内容";
        self.contentLabel.text = dic[@"course_content"];
    }
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    
   [UILabel changeSpaceForLabel:self.contentLabel withLineSpace:4.0 WordSpace:0.6];
//    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//    self.contentHeight.constant = contentSize.height;
    
    
    
    
}

@end
