//
//  MapDetalCourse.m
//  MasterKA
//
//  Created by 余伟 on 16/12/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MapDetalCourse.h"

@implementation MapDetalCourse
{
    UIImageView * _courseImage;
    UILabel     * _courseTitle;
    UILabel     * _address;
    UILabel     * _baoming;
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _courseImage = [[UIImageView alloc]init];
        _courseTitle = [[UILabel alloc]init];
        _address     = [[UILabel alloc]init];
        _baoming     = [[UILabel alloc]init];
        
        _courseTitle.font = [UIFont systemFontOfSize:14];
        _courseTitle.numberOfLines = 0;
         _address.font = [UIFont systemFontOfSize:13];
        _address.textColor = [UIColor colorWithHex:0xff7a31];
        
        _baoming.text = @"报名";
        _baoming.font = [UIFont systemFontOfSize:14];
        _baoming.textAlignment = NSTextAlignmentCenter;
        _baoming.backgroundColor = MasterDefaultColor;
        
        
        
        _courseTitle.textAlignment = NSTextAlignmentLeft;
        _address.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_courseTitle];
        [self addSubview:_courseImage];
        [self addSubview:_address];
        [self addSubview:_baoming];
        
        
//        _courseImage.image = [UIImage imageNamed:@"1_bg"];
//        _courseTitle.text = @"哈哈哈哈哈哈哈哈哈";
//        _address.text = @"xixiixixixixi";
        
    }
    [self layout];
    
    return self;
}


-(void)layout
{
    @weakify(self)
    [_courseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.width.height.equalTo(@60);
    }];
    
    [_courseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        @strongify(self)
        
        make.left.equalTo(_courseImage.mas_right).offset(10);
        make.right.equalTo(self).offset(-80);
        make.top.equalTo(self).offset(0);
        make.height.equalTo(@50);
        
    }];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        make.left.equalTo(_courseImage.mas_right).offset(10);
 //       make.right.equalTo(self).offset(-10);
        make.width.equalTo(@100);
        make.bottom.equalTo(_courseImage.mas_bottom);
        make.height.equalTo(@20);
    }];
    
    [_baoming mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self)
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-9);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
        
    }];
    
    
}


-(void)setModel:(MapModels *)model
{
    _model = model;
    
    
    [_courseImage setImageWithURLString:model.cover];
    _courseTitle.text = model.title;
    _address.text = model.store;
    
}

@end
