//
//  HomeTextField.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/18.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "HomeTextField.h"

@implementation HomeTextField
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    placeholderRect.origin.y += 1;
    return placeholderRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
