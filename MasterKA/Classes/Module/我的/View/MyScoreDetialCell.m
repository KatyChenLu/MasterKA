//
//  MyScoreDetialCell.m
//  MasterKA
//
//  Created by hyu on 16/4/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyScoreDetialCell.h"
#import "SDWebImageManager.h"
@implementation MyScoreDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCourse:(NSDictionary *)dic{
    [self.cover setImageWithURLString:dic[@"cover"] placeholderImage:[UIImage imageNamed:@"DefaultImage.png"]];
    self.title.text=[dic objectForKey:@"title"];
     self.store.text=[NSString stringWithFormat:@"%@  %@",[dic objectForKey:@"store"],[dic objectForKey:@"distance"]];
    self.m_price.text=[NSString stringWithFormat:@"%@ M点",[dic objectForKey:@"m_price"]];
}

@end
