//
//  NavCityBtn.m
//  MasterKA
//
//  Created by 余伟 on 16/8/2.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "NavCityBtn.h"

@implementation NavCityBtn

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect titleRect = self.titleLabel.frame;
    
    titleRect.origin.x = 0;
    
    self.titleLabel.frame = titleRect;
    
    CGRect imageRect = self.imageView.frame;
    
    imageRect.origin.x = self.titleLabel.frame.size.width+5;
    
    self.imageView.frame = imageRect;
    
}



@end
