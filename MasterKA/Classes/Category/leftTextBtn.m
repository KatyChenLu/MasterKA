//
//  leftTextBtn.m
//  MasterKA
//
//  Created by 余伟 on 17/1/5.
//  Copyright © 2017年 jinghao. All rights reserved.
//

#import "leftTextBtn.h"

@implementation leftTextBtn

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect imageRect =  self.imageView.frame;
    
    CGRect labelRect =  self.titleLabel.frame;
    
    labelRect.origin.x = (self.width-labelRect.size.width)/2;
    //    labelRect.size.width = labelRect.size.width;
    
    self.titleLabel.frame = labelRect;
    
    imageRect.origin.x = CGRectGetMaxX(labelRect);
    
    self.imageView.frame = imageRect;
    
    
}


@end
