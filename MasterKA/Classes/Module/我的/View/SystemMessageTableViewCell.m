//
//  SystemMessageTableViewCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/6/16.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@interface SystemMessageTableViewCell ()
@property (nonatomic,weak)IBOutlet UILabel* messageTimeView;
@property (nonatomic,weak)IBOutlet UILabel* messageTitleView;
@property (nonatomic,weak)IBOutlet UILabel* messageDescView;
@property (nonatomic,weak)IBOutlet UIView* messageLinkView;
@property (nonatomic,weak)IBOutlet UIImageView* messageImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descToImgConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descToTitleConstraint;


@property (nonatomic,weak)IBOutlet UIView* messageMoreView;

@end

@implementation SystemMessageTableViewCell

- (void)awakeFromNib {
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMoreView:)];
//    self.messageDescView.preferredMaxLayoutWidth = transitionSizeWithIphone(256);
//    [self.messageLinkView addGestureRecognizer:tap];
    [self clearCellData];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clearCellData{
    self.messageDescView.text = @"";
    self.messageImageView.hidden=YES;
    self.messageTimeView.text = @"";
    self.messageTitleView.text = @"";
    self.messageMoreView.hidden = YES;
    self.moreLayoutHeight.constant = 0.0f;
    self.descToImgConstraint.priority=250;
    self.descToTitleConstraint.priority=750;
}

- (void)setItemData:(id)itemData
{
    [self clearCellData];
    if (itemData) {
        self.messageTitleView.text = itemData[@"title"];
        self.messageDescView.text = itemData[@"content"]; 		
        self.messageTimeView.text = itemData[@"add_time"];
        NSString* picUrl = itemData[@"pic_url"];
        if(picUrl && ![picUrl isEqualToString:@""]){
            [self.messageImageView setImageWithURLString:picUrl];
            self.descToImgConstraint.priority=750;
            self.descToTitleConstraint.priority=250;
            self.messageImageView.hidden=NO;

        }
        NSString* targetType = itemData[@"target_type"];
        //（1：课程；2：达人；3：课程卡片；4：达人卡片；5：html5页面；6：课程关键字）'
//        if([targetType integerValue]>=1&&[targetType integerValue]<=6){
        if ([targetType  integerValue]>=1) {
            self.messageMoreView.hidden = NO;
            self.moreLayoutHeight.constant = 40;
        }
    }
    
}

- (void)onClickMoreView:(id)sender{
    
}

@end
