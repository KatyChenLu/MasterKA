//
//  longTouchLabel.m
//  MasterKA
//
//  Created by lijiachao on 16/8/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "longTouchLabel.h"

@implementation longTouchLabel

- (BOOL)canBecomeFirstResponder{
    return YES;
}

// 可以响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

// 针对响应方法的实现
- (void)copy:(id)sender{
    
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
}

// UILabel默认是不接收事件的，我们需要自己添加长按事件
- (void)longPressHander{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
}

// 绑定长按事件
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self longPressHander];
    }
    return self;
}

// 如果是用xib拖拽的
- (void)awakeFromNib{
    [super awakeFromNib];
    [self longPressHander];
}

// 处理长按事件
- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer{
    [self becomeFirstResponder];
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

@end
