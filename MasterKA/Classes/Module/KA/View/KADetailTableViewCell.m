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
    
    self.titleLabel.text = dic[@"title"];
    self.detailLabel.text = dic[@"nikename"];
    
       [self.imageView setImageWithURLString:dic[@"cover"] placeholderImage:nil];
   
   
}
@end
