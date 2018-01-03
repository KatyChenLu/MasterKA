//
//  KAPlaceAndMomentCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceAndMomentCell.h"

@implementation KAPlaceAndMomentCell


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
    
     [self.KAimgView setImageFadeInWithURLString:[dic[@"cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",(ScreenWidth- 24)*0.75*ScreenScale]] placeholderImage:[UIImage imageNamed:@"KAHoemLoadingDefault"]];
//    [self.KAimgView setImageWithURLString:[dic[@"cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",(ScreenWidth- 24)*0.75*ScreenScale]] placeholderImage:[UIImage imageNamed:@"KAHoemLoadingDefault"]];
    self.KAtitleLabel.text = dic[@"title"];
    self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.KApeopleNumLabel.text = [NSString stringWithFormat:@"可容纳%@人",dic[@"max_people_num"]];
    self.distanceLabel.hidden = NO;
    self.dotImg.hidden = NO;
    self.KAPlaceLabel.text = dic[@"short_addres"];
    self.distanceLabel.text = dic[@"distance"];
    
}
- (void)showMoment:(NSDictionary *)dic {
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
    self.KAtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.KApeopleNumLabel.text = dic[@"add_time"];
    self.KAPlaceLabel.text = dic[@"company_name"];
    self.distanceLabel.hidden = YES;
    self.dotImg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
