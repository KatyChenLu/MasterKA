//
//  CourseV3CommentReplyTableViewCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/10/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "CourseV3CommentReplyTableViewCell.h"

@interface CourseV3CommentReplyTableViewCell ()
@property (nonatomic,weak)IBOutlet UILabel* replyContentView;
@end

@implementation CourseV3CommentReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItemData:(id)itemData{
    _itemData = itemData;
    
    NSString* nickName = [NSString stringWithFormat:@"%@：",itemData[@"nickName"]];
    NSString* replyContent = [NSString stringWithFormat:@"%@%@",nickName,itemData[@"content"]];
    UIColor* nickNameColor = [UIColor colorWithRed:61/255.0 green:159/255.0 blue:215/255.0 alpha:1];
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc] initWithString:replyContent];
    NSRange range = [replyContent rangeOfString:nickName];
    [strAttr addAttribute:NSForegroundColorAttributeName value:nickNameColor range:range];
    [self.replyContentView setEmojiText:replyContent];
//    self.replyContentView.text = replyContent;
}

@end
