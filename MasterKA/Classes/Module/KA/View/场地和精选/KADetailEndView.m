//
//  KADetailEndView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailEndView.h"

@implementation KADetailEndView
+ (instancetype)endView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"KADetailEndView" owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
