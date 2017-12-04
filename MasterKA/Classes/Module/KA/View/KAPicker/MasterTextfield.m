//
//  MasterTextfield.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/17.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "MasterTextfield.h"

@interface MasterTextfield()
@property (nonatomic, strong) UIView *tapView;

@end
@implementation MasterTextfield
-(void)setTapActionBlock:(MasterTFTapActionBlock)tapActionBlock {
    _tapActionBlock = tapActionBlock;
    self.tapView.hidden = NO;
}



- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc]initWithFrame:self.bounds];
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTextField)];
        [_tapView addGestureRecognizer:myTap];
    }
    return _tapView;
}

- (void)didTapTextField {
    // 响应点击事件时，隐藏键盘
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
    NSLog(@"点击了textField，执行点击回调");
    if (self.tapActionBlock) {
        self.tapActionBlock();
    }
}

- (void)didEndEditTextField:(UITextField *)textField {
    NSLog(@"textField编辑结束，回调编辑框输入的文本内容:%@", textField.text);
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}

@end
