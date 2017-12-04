//
//  KAEndView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/1.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAEndView.h"

@implementation KAEndView
+ (instancetype)endView {
    return [[[NSBundle mainBundle] loadNibNamed:@"KAEndView" owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
