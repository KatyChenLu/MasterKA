//
//  LoadingFailView.m
//  MasterKA
//
//  Created by jinghao on 16/1/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "LoadingFailView.h"

@interface LoadingFailView ()
@property (nonatomic,strong)UIImageView *failImageView;
@property (nonatomic,strong)UILabel *failLabelView;
@property (nonatomic,strong)UIView *failView;

@end

@implementation LoadingFailView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (id)init{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    _failView = [[UIView alloc] init];
    [self addSubview:_failView];
    _failImageView = [[UIImageView alloc] init];
    _failImageView.image =[UIImage imageNamed:@"app_logo"];
    [_failView addSubview:_failImageView];
    _failLabelView = [[UILabel alloc] init];
    _failLabelView.textAlignment = NSTextAlignmentCenter;
    _failLabelView.text = @"加载失败，点击重新加载";
    [_failView addSubview:_failLabelView];
    
    _failView.backgroundColor = [UIColor redColor];
    // 防止block中的循环引用
    __weak typeof (self) weakSelf = self;
    
    [self.failView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
    }];
    [self.failImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.failView);
        make.centerX.equalTo(weakSelf.failView.mas_centerX);
        make.bottom.equalTo(weakSelf.failLabelView.mas_top);
    }];
    [self.failLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(weakSelf.failView);
    }];
    [self.failView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        weakSelf.hidden = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
