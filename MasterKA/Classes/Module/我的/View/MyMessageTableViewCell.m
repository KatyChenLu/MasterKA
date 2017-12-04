//
//  MyMessageTableViewCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/6/8.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "MyMessageTableViewCell.h"

@interface MyMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView* headerImageView;
@property (weak, nonatomic) IBOutlet UILabel* titleLabelView;
@property (weak, nonatomic) IBOutlet UILabel* descLabelView;
@property (weak, nonatomic) IBOutlet UILabel* timeLabelView;
@end

@implementation MyMessageTableViewCell

- (void)awakeFromNib {
    
    [self clearCellData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)clearCellData{
    self.badgeView.hidden = TRUE;
    self.headerImageView.image = nil;
    self.timeLabelView.text = @"";
    self.titleLabelView.text =@"";
    self.descLabelView.text = @"";
    self.accessoryType = UITableViewCellAccessoryNone;
}
- (void)setItemData:(id)itemData
{
    _itemData = itemData;
    [self clearCellData];
    if (itemData) {
        NSNumber* num = itemData[@"num"];
        if(num.integerValue>0){
            self.badgeView.hidden = FALSE;
        }
        [self.headerImageView setImageWithURLString:itemData[@"img_top"]];
        //        self.messageLabelView.text = data[@"message"];
//        [self.descLabelView setEmojiText:itemData[@"message"]];
        self.descLabelView.text = itemData[@"message"];
        self.titleLabelView.text = itemData[@"nikename"];
        self.timeLabelView.text = itemData[@"comment_time"];
        //       type  1：私信 2：评论 3：回复 4：系统通知
//        NSString* type = [NSString stringWithFormat:@"%@",itemData[@"type"]] ;;
//        
//        if ([type isEqualToString:@"1"]) {
//            NSString* messageType = [NSString stringWithFormat:@"%@",itemData[@"cid"]] ;
//            if ([messageType isEqualToString:@"2"]) {
//                self.descLabelView.text = @"[图片]";
//            }
//        }else if ([type isEqualToString:@"4"]){
//            self.timeLabelView.text = @"";
//            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
    }
}

- (void)setItemDataComment:(id)itemData
{
    _itemData = itemData;
    [self clearCellData];
    if (itemData) {
        [self.headerImageView setImageWithURLString:itemData[@"img_top"]];
        self.titleLabelView.text = itemData[@"nikename"];
        self.timeLabelView.text = itemData[@"comment_time"];
        NSString *content = [itemData[@"reply_content"] isEqualToString:@""] ? itemData[@"content"] : itemData[@"reply_content"];
        self.descLabelView.text = content;

    }
}

@end
