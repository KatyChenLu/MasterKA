//
//  KAImageTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/7.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAImageTableViewCell.h"

@implementation KAImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showContentImg:(NSDictionary *)dic {
    
    self.imageHeight.constant =0;
    
    if ([dic[@"width"] integerValue] <ScreenWidth-24) {
        
        self.imageWidth.constant = [dic[@"width"] integerValue];
        self.imageHeight.constant = [dic[@"height"] integerValue];
        [self.contentImgView setImageWithURLString:dic[@"url"] placeholderImage:nil];
    }else {
        CGFloat num = [dic[@"height"] integerValue]*(ScreenWidth -24)/[dic[@"width"] integerValue];
        
        self.imageWidth.constant = ScreenWidth-24;
        self.imageHeight.constant = num;
        [self.contentImgView setImageWithURLString:[dic[@"url"] ClipImageUrl:[NSString stringWithFormat:@"%f",ScreenWidth- 24]] placeholderImage:nil];
    }
   
    
    
    
}
@end
