//
//  PopControllerToolsView.m
//  MasterKA
//
//  Created by jinghao on 16/5/9.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "PopControllerToolsView.h"

@interface PopControllerToolsView ()
@property (nonatomic,weak)IBOutlet NSLayoutConstraint *cancleLayoutLeft;
@end

@implementation PopControllerToolsView

- (void)awakeFromNib
{
    self.showCancleButton = NO;
    self.titleView.text =@"";
}

- (void)setShowCancleButton:(BOOL)showCancleButton
{
    _showCancleButton = showCancleButton;
    self.cancleButton.hidden = !showCancleButton;
    if (showCancleButton) {
        self.cancleLayoutLeft.constant = 0.0f;
    }else{
        self.cancleLayoutLeft.constant = -self.cancleButton.width;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
