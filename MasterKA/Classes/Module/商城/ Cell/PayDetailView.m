//
//  PayDetailView.m
//  MasterKA
//
//  Created by 余伟 on 16/8/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "PayDetailView.h"
#import "masonry.h"
@implementation PayDetailView
{
    UIImageView * _couserImageView;
    UILabel * _courseNameLabel;
    UILabel * _masterNameLabel;
    UILabel * _priceLabel;
    UILabel * _originalPriceLabel;
    UILabel * _distanceLabel;
    UIView * _bottomLine;
    UIImageView * _groupImageView;
    UILabel * _groupLabel;
    
    UIView * _lineView;
    }

-(instancetype)init
{

    if ( self = [super init]) {
        
        _couserImageView = [[UIImageView alloc]init];
        _courseNameLabel = [[UILabel alloc]init];
        
        _couserImageView.image = [UIImage imageNamed:@"ka"];
        
        _masterNameLabel = [[UILabel alloc]init];
        
        _masterNameLabel.textColor = [UIColor colorWithHex:0x787878];
        
        _priceLabel = [[UILabel alloc]init];
        
        _priceLabel.textColor = [UIColor redColor];
        
        _priceLabel.font = [UIFont systemFontOfSize:20];
        
        _originalPriceLabel = [[UILabel alloc]init];
        
        _distanceLabel = [[UILabel alloc]init];
        
        _bottomLine = [[UIView alloc]init];
        
        _bottomLine.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        
        _groupImageView = [[UIImageView alloc]init];
        
        _groupImageView.image = [UIImage imageNamed:@"tuan"];
        
        _groupLabel = [[UILabel alloc]init];
        
        _lineView = [[UIView alloc]init];
        
        [self addSubview:_couserImageView];
        [self addSubview:_courseNameLabel];
        [self addSubview:_masterNameLabel];
        [self addSubview:_priceLabel];
        [self addSubview:_originalPriceLabel];
        [self addSubview:_distanceLabel];
        [self addSubview:_bottomLine];
        [self addSubview:_groupImageView];
        [self addSubview:_groupLabel];
        [self addSubview:_lineView];

       
        
    }
      return self;
}



-(void)layoutUi
{
    
    
    [_couserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(10);
        make.width.height.mas_equalTo(80);
    }];
    
    [_courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_couserImageView.mas_right).offset(10);
        make.top.equalTo(_couserImageView).offset(10);
        
    }];
    
    [_masterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_courseNameLabel);
        make.top.mas_equalTo(_courseNameLabel.mas_bottom).offset(3);
        
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_masterNameLabel);
        make.top.mas_equalTo(_masterNameLabel.mas_bottom).offset(3);
        
    }];
    
    [_originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_priceLabel.mas_right).offset(3);
        make.bottom.equalTo(_priceLabel);
        
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_originalPriceLabel).offset(-2);
        make.top.mas_equalTo(_originalPriceLabel.mas_centerY).offset(10);
        make.right.equalTo(_originalPriceLabel).offset(2);
        make.height.equalTo(@1);
        
        
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-3);
        make.top.mas_equalTo(_couserImageView.mas_bottom);

    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_couserImageView);
        make.top.mas_equalTo(_distanceLabel.mas_bottom).offset(20);
        make.right.equalTo(_distanceLabel);
        make.height.equalTo(@1);
        
    }];
    
    
    [_groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_couserImageView);
        make.top.mas_equalTo(_bottomLine.mas_bottom).offset(10);
        make.width.height.equalTo(@20);
    
    }];
    
    [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_groupImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(_groupImageView.mas_centerY);
        
    }];
}




-(void)setInfoDic:(NSDictionary *)infoDic

{
    
    _infoDic = infoDic;
    
    [_couserImageView setImageWithURLString:infoDic[@"cover"] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    
    _courseNameLabel.text = infoDic[@"title"];
    
    _masterNameLabel.text = infoDic[@"nikename"];
    
    float p = [infoDic[@"price"] floatValue] - [infoDic[@"groupbuy_price"] floatValue];
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f" , [infoDic[@"groupbuy_price"] floatValue]];
    
    _groupLabel.text = [NSString stringWithFormat:@"组团满%@人,立减%.2f元",infoDic[@"groupbuy_num"] ,p];
    
    
     [self layoutUi];
}



@end
