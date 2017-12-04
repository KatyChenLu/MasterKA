//
//  KAPlaceTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/27.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceTableViewCell.h"


@implementation KAPlaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showPlaces:(NSDictionary *)dic {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 3.0;
    
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dictionary = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.7f
                                 };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:dic[@"intro"]attributes:dictionary];
    
    self.KAcontentLabel.numberOfLines = 2;
    
    self.KAcontentLabel.attributedText = attributeStr;
    
    
    [self.KAimgView setImageWithURLString:dic[@"cover"] placeholderImage:nil];
    self.KAtitleLabel.text = dic[@"title"];
//    self.KAcontentLabel.text = dic[@"intro"];
    self.KApeopleNumLabel.text = [NSString stringWithFormat:@"可容纳%@人",dic[@"max_people_num"]];
    self.KAPlaceLabel.text = dic[@"short_addres"];
    self.distanceLabel.text = dic[@"distance"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
