//
//  PaySuccessCell.m
//  MasterKA
//
//  Created by 余伟 on 16/8/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "PaySuccessCell.h"
#import "PayDetailView.h"

@implementation PaySuccessCell

{
    
    UIView * _headView;
    PayDetailView * _detailView;
    
    
    UIImageView * _imageView;
    UILabel * _successLabel;
    UILabel * _invitelabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headView = [self HeadView];
        
        _headView.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
        _detailView = [[PayDetailView alloc]init];
        _detailView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_headView];
        
        [self.contentView addSubview:_detailView];
        
        [self layoutUi];

       
    }
    
    return  self;
    
}



-(UIView *)HeadView
{
    
    _headView = [[UIView alloc]init];
    
   _imageView = [[UIImageView alloc]init];
    
    _imageView.image = [UIImage imageNamed:@"right"];
    
    _successLabel = [[UILabel alloc]init];
    
    _successLabel.text = @"购买成功";
    
    _invitelabel = [[UILabel alloc]init];
    
    _invitelabel.text = @"快去邀请好友加入吧～";
    
    _invitelabel.textColor = [UIColor colorWithHex:0x787878];
    
    [_headView addSubview:_imageView];
    [_headView addSubview:_successLabel];
    [_headView addSubview:_invitelabel];
    
     [self layoutHeadView];
    
    return _headView;
}



-(void)layoutHeadView
{
    
    
    [_successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
        make.centerX.mas_equalTo(_headView.mas_centerX);
        make.centerY.mas_equalTo(_headView.mas_centerY).offset(-16);
        
        
    }];
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_successLabel.mas_left).offset(-3);
        
        make.centerY.mas_equalTo(_successLabel.mas_centerY);
        
//        make.width.equalTo(@30);
//        make.bottom.equalTo(_successLabel);
        
    }];
    
    [_invitelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_successLabel.mas_bottom).offset(9);
        make.centerX.mas_equalTo(_successLabel.mas_centerX);
        
    }];
    
}




-(void)layoutUi
{
    @weakify(self)
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
        
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(105);
    }];
   
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_headView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(170);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
   
    }];
//
   
    
    
}


-(void)setInfoDic:(NSDictionary *)infoDic

{
    _infoDic = infoDic;
    
    _detailView.infoDic = _infoDic;
    
}


@end
