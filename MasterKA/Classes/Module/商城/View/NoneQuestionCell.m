//
//  NoneQuestionCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/8/14.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "NoneQuestionCell.h"

@implementation NoneQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.questionBtn.layer.borderWidth = 1;
    self.questionBtn.layer.cornerRadius = 10;
    self.questionBtn.layer.masksToBounds = YES;
    self.questionBtn.layer.borderColor = RGBFromHexadecimal(0xff5a00).CGColor;
}
- (IBAction)qusetionBtnAction:(id)sender {
    self.moreClick();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
