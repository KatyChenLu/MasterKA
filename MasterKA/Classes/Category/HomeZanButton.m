//
//  HomeZanButton.m
//  MasterKA
//
//  Created by 陈璐 on 2017/3/23.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "HomeZanButton.h"

@implementation HomeZanButton
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect imageRect =  self.imageView.frame;
    
    CGRect labelRect =  self.titleLabel.frame;
    
    
    imageRect.size = CGSizeMake(14, 12);
    
    imageRect.origin.x = (self.width-imageRect.size.width-labelRect.size.width)/2;
    imageRect.origin.y = (self.height-imageRect.size.height-9)/2;
    
    self.imageView.frame = imageRect;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
