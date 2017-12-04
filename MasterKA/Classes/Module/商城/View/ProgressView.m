//
//  ProgressView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ProgressView.h"


@implementation ProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)progress
{
    ProgressView * progress = [[[NSBundle mainBundle]loadNibNamed:@"ProgressView" owner:nil options:nil]lastObject];
    
    return progress;
    
}

-(void)setDic:(id)dic
{
    _dic = dic;
    
    self.timeLabel.text = [NSString stringWithFormat:@"(%@%@)",dic[@"item_time"],dic[@"time_unit"]];
    
    self.contentLabel.text = dic[@"item_content"];
    
}



@end
