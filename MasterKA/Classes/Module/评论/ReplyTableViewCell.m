//
//  ReplyTableViewCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/2/5.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//回复评论的Cell

#import "ReplyTableViewCell.h"
@implementation ReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self resetItemData];
//    self.replyContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetItemData{
    self.nickNameLabel.text = nil;
    self.timeReplyLabel.text =  nil;
    self.replyContentLabel.text = nil;
}
- (void)setItemData:(id)itemData
{
    [self resetItemData];
    if (itemData) {
        NSString* nickName = [NSString stringWithFormat:@"%@：",itemData[@"nikename"]];
        NSString* replyContent = [NSString stringWithFormat:@"%@%@",nickName,itemData[@"content"]];
        UIColor* nickNameColor = [UIColor colorWithRed:61/255.0 green:159/255.0 blue:215/255.0 alpha:1];
        NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:replyContent];
        NSRange range = [replyContent rangeOfString:nickName];
        [strAttr addAttribute:NSForegroundColorAttributeName value:nickNameColor range:range];
        [self.nickNameLabel setEmojiText:replyContent];
//        self.nickNameLabel.attributedText = strAttr;
        
        self.timeReplyLabel.text = itemData[@"addTime"];
    }
}

@end
