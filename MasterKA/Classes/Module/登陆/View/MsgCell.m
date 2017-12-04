//
//  MsgCell.m
//  MasterKA
//
//  Created by 余伟 on 16/7/7.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MsgCell.h"
#import "Masonry.h"

@implementation MsgCell

{
    
    UILabel * _nikeName;
    
    UITextField * _name;
    
    
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _nikeName = [[UILabel alloc]init];
        
        _name = [[UITextField alloc]init];
        
        _name.textAlignment = NSTextAlignmentRight;
        
        
        [self.contentView addSubview:_nikeName];
        [self.contentView addSubview:_name];
    }
    
    [self layoutUI];
    
    return  self;
}






-(void)layoutUI {
    
    [_nikeName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.contentView.top).offset(15);
        
        make.left.mas_equalTo(self.contentView.left).offset(15);
 
        
    }];
    
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.top).offset(15);
        
        make.right.mas_equalTo(self.contentView.right).offset(-15);
        
        make.width.mas_equalTo(100);
        
    }];
    
    
}


-(void)setNameStr:(NSString *)nameStr
{
    
    _nameStr = nameStr;
    
    if (nameStr != nil ) {
        
        
        _name.text = _nameStr;
        
    }
}


-(void)setNike:(NSString *)nike
{
    _nike = nike;
    
    
    _nikeName.text = nike;
    
}


@end
