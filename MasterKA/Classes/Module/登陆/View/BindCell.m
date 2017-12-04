//
//  BindCell.m
//  MasterKA
//
//  Created by 余伟 on 16/7/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BindCell.h"
#import "Masonry.h"

@implementation BindCell
{
    
    UIImageView * _icon;
    UILabel * _icomName;
    UILabel * _bindState;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _icon = [[UIImageView alloc]init];
        
        _icomName = [[UILabel alloc]init];
        
        _icomName.textAlignment = NSTextAlignmentCenter;
        
        _bindState = [[UILabel alloc]init];
        
        _bindState.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_icon];
        [self.contentView addSubview:_icomName];
        
        [self. contentView addSubview:_bindState];
        

        
    }
    
    [self layoutUI];
    
    return self;
    
    
}





-(void)layoutUI{
    
  
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView).offset(15);
        
        make.top.mas_equalTo(self.contentView).offset(15);
      
        make.width.height.mas_equalTo(16);
        
        
    }];
    
    [_icomName mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.left.mas_equalTo(_icon).offset(5);
        
        make.top.mas_equalTo(self.contentView).offset(15);
        
        make.width.mas_equalTo(100);
        
        make.height.mas_equalTo(16);
        
    }];
//
    [_bindState mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.contentView).offset(-1);
        
        make.top.mas_equalTo(self.contentView).offset(15);
        
        make.width.mas_equalTo(200);
        
        make.height.mas_equalTo(16);
       
        
    }];
    
    
}


-(void)setIconStr:(NSString *)iconStr
{

    _iconStr = iconStr;
    
    _icomName . text = iconStr;
}


-(void)setImageStr:(NSString *)imageStr
{
    _icon.image = [UIImage imageNamed:imageStr];
}

-(void)setStatueStr:(NSString *)statueStr
{
    
    _bindState.text = statueStr;
}




@end
