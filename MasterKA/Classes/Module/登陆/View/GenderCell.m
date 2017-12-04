//
//  GenderCell.m
//  MasterKA
//
//  Created by 余伟 on 16/7/7.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GenderCell.h"

#import "SevenSwitch.h"


@implementation GenderCell

{
    UILabel * _gender;
    
    SevenSwitch * _genderSwitch;
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _gender = [[UILabel alloc]init];
        
        
        _genderSwitch  = [[SevenSwitch alloc]init];
        
        [_genderSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        _genderSwitch.offImage = @"女";
        _genderSwitch.onImage = @"男";

        
        _genderSwitch.onColor =[UIColor colorWithRed:0.f green:150/255.f  blue:230/255.f  alpha:1.f];
      
        _genderSwitch.borderColor=_genderSwitch.inactiveColor =[UIColor colorWithRed:227/255.f green:102/255.f  blue:165/255.f  alpha:1.f];
        
        [self.contentView addSubview:_gender];
        [self.contentView addSubview:_genderSwitch];
    }
    
    [self layoutUI];
    
    return  self;
}


-(void)layoutUI {
    
    [_gender mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.top).offset(15);
        
        make.left.mas_equalTo(self.contentView.left).offset(15);
        
        
    }];
    
    
    
    [_genderSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.top.mas_equalTo(self.contentView.top).offset(5);
        
        make.right.mas_equalTo(self.contentView.right).offset(-15);
        
        make.width.mas_equalTo(70);
        
        make.height.mas_equalTo(30);
        
        
    }];
    
      
    
}

-(void)setGenderStr:(NSString *)genderStr
{
    
    _genderStr = genderStr;
    
    _gender.text = genderStr;
    
}


- (void)switchChanged:(SevenSwitch *)sender {
    
    NSString * genderStr ;
    
    if ([sender isOn]) {
        
       
        genderStr = @"1";
    }else{
        genderStr = @"2";
    }
    
   
    
    self.saveGender(genderStr);
    
    
}


@end
