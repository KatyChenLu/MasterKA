//
//  ShareBtn.m
//  MasterKA
//
//  Created by 余伟 on 16/10/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ShareBtn.h"

@implementation ShareBtn

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect imageRect =  self.imageView.frame;
    
    CGRect labelRect =  self.titleLabel.frame;
    
    imageRect.origin.x = (self.width-26)/2;
    
    imageRect.origin.y = (self.height-labelRect.size.height-26)/2;
    
    imageRect.size.width = 26;
    imageRect.size.height = 26;
    
    self.imageView.frame = imageRect;
    
    labelRect.origin.x = 0;
    
    
    labelRect.size.width = self.size.width;
    
    
    labelRect.origin.y = 26+(self.height-26-labelRect.size.height)/2+4;
    
    self.titleLabel.frame = labelRect;
    
}


@end
