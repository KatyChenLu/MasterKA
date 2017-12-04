//
//  ClickLikeCell.m
//  MasterKA
//
//  Created by 余伟 on 16/8/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ClickLikeCell.h"

@implementation ClickLikeCell
{
    
    UIImageView * _imageFirst;
    UILabel * _nameLab;
    UILabel * _likeLab;
    UILabel * _dateLab;
    UIImageView * _imageSecond;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageFirst = [[UIImageView alloc]init];
        
//        _imageFirst.backgroundColor = [UIColor redColor];
     
        _nameLab =[[ UILabel alloc]init];
         _nameLab.font = [UIFont systemFontOfSize:13];
        
        _likeLab = [[UILabel alloc]init];
        
        _likeLab.text = @"赞了";
        _likeLab.font = [UIFont systemFontOfSize:13];
        
        _likeLab.textColor = [UIColor lightGrayColor];
        
        _dateLab = [[UILabel alloc]init];
        
        _dateLab.font = [UIFont systemFontOfSize:13];
       _imageSecond = [[UIImageView alloc]init];
        
//        _imageSecond.backgroundColor = [UIColor yellowColor];
        
        [self.contentView addSubview:_imageFirst];
        
        [self.contentView addSubview:_nameLab];
        
        [self.contentView addSubview:_likeLab];
        
        [self.contentView addSubview:_dateLab];
        
        [self.contentView addSubview:_imageSecond];
        
    }
    
    
    return self;
    
}







-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.left.equalTo(self.contentView).offset(10);
        
        make.top.equalTo(self.contentView).offset(10);
        
        make.height.mas_equalTo(43);
        
        make.width.mas_equalTo(43);
        
    }];
    
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_imageFirst.mas_right).offset(10);
        
        make.top.equalTo(_imageFirst);

        
    }];
//
//    
    [_likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.left.mas_equalTo(_nameLab.mas_right).offset(5);
        make.top.equalTo(_nameLab);
        
    }];
//
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_imageFirst.mas_right).offset(10);
        
        make.bottom.mas_equalTo(_imageFirst.mas_bottom).offset(-5);
        
        
    }];
    
    [_imageSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_imageFirst);
        
        make.right.equalTo(self.contentView).offset(-10);
        
        make.height.mas_equalTo(43);
        
        make.width.mas_equalTo(43);
        
        
    }];
    
}


-(void)setModel:(ClickLikeModel *)model
{
    
    _model = model;
    
    [_imageFirst setImageWithURLString:model.img_top];
    
    _nameLab.text = model.nikename;
    
    _dateLab.text = model.add_time;
    
    [_imageSecond setImageWithURLString:model.cover];
    
    
}



@end
