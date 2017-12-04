//
//  ZanButton.m
//  MasterKA
//
//  Created by 陈璐 on 2017/3/23.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "ZanButton.h"

@implementation ZanButton
- (void)likeAnimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.values = @[@1.4, @1.0];
    
    animation.duration = 0.3;
    
    animation.calculationMode = kCAAnimationCubic;
    
    [self.imageView.layer addAnimation:animation forKey:@"transform.scale"];
    
}
- (void)dislikeAnimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.values = @[@1.0, @0.01];
    
    animation.duration = 0.3;
    
    animation.calculationMode = kCAAnimationCubic;
    
    [self.imageView.layer addAnimation:animation forKey:@"transform.scale"];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
