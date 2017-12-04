//
//  CLPaoPaoView.m
//  HiMaster3
//
//  Created by ChenLu on 2017/6/6.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "CLPaoPaoView.h"

@implementation CLPaoPaoView

- (void)layoutSubviews {
    [super layoutSubviews];
    [_weizhiLabel setPreferredMaxLayoutWidth:200.0];
}

- (IBAction)daohangAction:(id)sender {
    self.block();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
