//
//  GroupMethodCell.m
//  MasterKA
//
//  Created by 余伟 on 16/8/31.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GroupMethodCell.h"

@interface GroupMethodCell ()

@end

@implementation GroupMethodCell
{
    UILabel * _methodLabel;
    UILabel *_progressOne;
    UILabel *_progressTwo;
    UILabel *_progressThree;
   
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
       _methodLabel = [[UILabel alloc]init];
        _methodLabel.text = @"拼团玩法";
        
        _progressOne = [[UILabel alloc]init];
        _progressOne.text = @"1.选择课程";
        _progressOne.textColor = [UIColor colorWithHex:0x787878];
        
        _progressOne.font = [UIFont systemFontOfSize:13];
        _progressTwo = [[UILabel alloc]init];
        _progressTwo.text = @"2.加入拼团";
        _progressTwo.textColor = [UIColor colorWithHex:0x787878];
        _progressTwo.font = [UIFont systemFontOfSize:13];
        _progressThree = [[UILabel alloc]init];
        _progressThree.text = @"3.完成支付，邀请好友，满团开课";
        _progressThree.font = [UIFont systemFontOfSize:13];
        _progressThree.textColor = [UIColor colorWithHex:0x787878];
        
        
        [self.contentView addSubview:_methodLabel];
        [self.contentView addSubview:_progressOne];
        [self.contentView addSubview:_progressTwo];
        [self.contentView addSubview:_progressThree];
        
        [self layoutUi];
    
    }
    
    return  self;
    
    
}




-(void)layoutUi
{
    
    @weakify(self)
    [_methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self)
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(10);
        
    }];
    
    [_progressOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_methodLabel.mas_bottom).offset(30);
        make.left.equalTo(self.contentView).offset(10);
        
    }];
    
    [_progressTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_methodLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(_progressOne.mas_right).offset(10);
        
    }];
    
    [_progressThree mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_methodLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(_progressTwo.mas_right).offset(10);
      

        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    

    
    
}

//




@end
