//
//  KAMomentHeaderView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAMomentHeaderView.h"

@implementation KAMomentHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)showDetailHeaderView:(NSDictionary *)dic {
    self.userName.text = dic[@"moment_username"];
    self.userName.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.userIntro.text = dic[@"moment_intro"];
    self.markLabel.text = dic[@"moment_mark"];
    self.markLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [UILabel changeSpaceForLabel:self.markLabel withLineSpace:5.0 WordSpace:0.7];
    NSString *trueWidth = @"50";
    [self.imgTopView setImageFadeInWithURLString:[dic[@"moment_img_top"] ClipImageUrl:trueWidth] placeholderImage:nil];
    CGSize contentSize = [self boundingRectWithSize:CGSizeMake(ScreenWidth-56, MAXFLOAT) WithStr:self.markLabel.text andFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] andLinespace:5.0];
     self.markBGHeight.constant = contentSize.height + 53 +30;
      self.markViewHeight.constant = contentSize.height + 70+30;
    self.totleHeight = contentSize.height + 70+30 + 66 +100;
}

- (CGSize)boundingRectWithSize:(CGSize)size WithStr:(NSString*)string andFont:(UIFont *)font andLinespace:(CGFloat)space
{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:space];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    CGSize retSize = [string boundingRectWithSize:size
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    return retSize;
}
@end
