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
    self.userIntro.text = dic[@"moment_intro"];
    self.markLabel.text = dic[@"moment_mark"];
    NSString *trueWidth = @"50";
    [self.imgTopView setImageFadeInWithURLString:[dic[@"moment_img_top"] ClipImageUrl:trueWidth] placeholderImage:nil];
}
@end
