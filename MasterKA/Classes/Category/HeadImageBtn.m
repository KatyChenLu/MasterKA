
//
//  HeadImageBtn.m
//  MasterKA
//
//  Created by 余伟 on 16/10/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HeadImageBtn.h"

@implementation HeadImageBtn

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect imageRect =  self.imageView.frame;
    
    CGRect labelRect =  self.titleLabel.frame;
    
    imageRect.origin.x = (self.width-30)/2;
    
    imageRect.origin.y = (self.height-labelRect.size.height-30)/2;
    
    imageRect.size.width = 30;
    imageRect.size.height = 30;
    
    self.imageView.frame = imageRect;
    
    labelRect.origin.x = 0;
    
    labelRect.size.width = self.size.width;
    
    labelRect.origin.y = 30+(self.height-30-labelRect.size.height)/2+4;
    
    self.titleLabel.frame = labelRect;
    
}


@end
