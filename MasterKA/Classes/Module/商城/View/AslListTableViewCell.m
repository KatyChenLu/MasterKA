//
//  AslListTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AslListTableViewCell.h"

@implementation AslListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showAskList:(NSDictionary *)dic {
    self.askLabel.text = dic[@"question_content"];
    self.answerLabel.text = dic[@"answer_content"];
    self.answerNumLabel.text = [NSString stringWithFormat:@"查看%@个回答",dic[@"answer_count"]];
    self.timeLabel.text = dic[@"question_time"];
    self.questionId = dic[@"question_id"];
    
    if ([dic[@"answer_count"] isEqualToString:@"0"]) {
        self.answerNumTop.constant = 30;
    }
    
}

@end
