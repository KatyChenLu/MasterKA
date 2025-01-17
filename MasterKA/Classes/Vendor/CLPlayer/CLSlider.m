//
//  Slider.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/2.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLSlider.h"

@implementation CLSlider


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImage *thumbImage = [UIImage imageNamed:@"CLRound"];
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}


// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds{
    [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, CGRectGetWidth(bounds), 2);
}
//修改滑块位置
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 6 ;
    rect.size.width = rect.size.width + 12;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}

@end
