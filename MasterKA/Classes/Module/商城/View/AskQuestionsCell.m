//
//  AskQuestionsCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/9.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "AskQuestionsCell.h"


@implementation AskQuestionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.showAllButton.layer.borderWidth    = 1;
    self.showAllButton.layer.cornerRadius   = 10;
    self.showAllButton.layer.masksToBounds  = YES;
    self.showAllButton.layer.borderColor    = RGBFromHexadecimal(0xff5a00).CGColor;
    
}
- (IBAction)showAllAction:(id)sender {

    self.moreClick();
}

- (void)showAskCell:(NSDictionary *)dic {
    self.askLabel.text      = dic[@"question_content"];
    self.askNumLabel.text   = [NSString stringWithFormat:@"%@个回答",dic[@"answer_count"]];
    self.answerLabel.text   = dic[@"answer_content"];
    self.questionTime       = dic[@"question_time"];
    self.questionId         = dic[@"question_id"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
