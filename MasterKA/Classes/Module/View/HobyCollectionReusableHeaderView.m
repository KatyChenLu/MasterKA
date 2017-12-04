//
//  HobyCollectionReusableHeaderView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HobyCollectionReusableHeaderView.h"

@implementation HobyCollectionReusableHeaderView
{
    
    UILabel * _likeLabeL;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _likeLabeL = [[UILabel alloc]init];
        _likeLabeL.textAlignment = NSTextAlignmentCenter;
        _likeLabeL.text          = @"喜欢什么爱好?";
        [self addSubview:_likeLabeL];
    }
    self.backgroundColor = [UIColor grayColor];
    
    [self layout];
    return self;
}


-(void)layout
{
    
    
    [_likeLabeL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self).offset(-15);
        make.top.equalTo(self);
        make.right.mas_equalTo(self).offset(15);
        make.bottom.equalTo(self);
        
    }];
    
}


@end
