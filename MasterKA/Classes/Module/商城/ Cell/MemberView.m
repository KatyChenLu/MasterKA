//
//  MemberView.m
//  MasterKA
//
//  Created by 余伟 on 16/8/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#define Margin 28
#define avgWidth @(([UIScreen mainScreen].bounds.size.width-6*Margin)/counts)
#define counts 5

#import "MemberView.h"

#import "CLCountDownView.h"

@implementation MemberView

{
    UILabel * _groupLabel;
    UIView * _timeView;
    UIView * _memberView;
    
    UIImageView * _memberImage;
    
    
    UILabel * _timeLabel;
    UILabel * _endLabel;
    
    
    NSMutableArray * _memberArr;
    CLCountDownView *_countDownView;
}


-(instancetype)initWithNum:(int)num

{
    if (self = [super init]) {
        
        _groupLabel = [[UILabel alloc]init];
        
        _groupLabel.text = @"拼团团员";
        _timeView = [self layoutTime];
        _memberView = [self layoutMemberWithNumber:num];
        
        [self addSubview:_groupLabel];
        [self addSubview:_timeView];
        [self addSubview:_memberView];
        
        [self layoutUi];
        
        
        
    }
    return self;
}






-(UIView*)layoutMemberWithNumber:(int)number
{
    
    _memberArr = [NSMutableArray arrayWithCapacity:10];
    
    _memberView = [[UIView alloc]init];
    
    if (number != 0) {
        
        for (int i = 0; i < number; i++) {
            
            UIImageView * memberImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal层-20"]];
            
            memberImage.layer.cornerRadius = [avgWidth integerValue]/2;
            
            memberImage.layer.masksToBounds = YES;
            
            [_memberView addSubview:memberImage];
            
            [memberImage mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(_memberView).offset(Margin+i%counts*([avgWidth integerValue]+Margin));
                make.top.mas_equalTo(_memberView).offset(Margin + i / counts *([avgWidth integerValue]+Margin));
                make.width.height.equalTo(avgWidth);
                //                if (i==number-1) {
                //
                //
                //                    make.bottom.mas_equalTo(_memberView.mas_bottom).offset(-20);
                //                }
                
            }];
            
            
            [_memberArr addObject:memberImage];
        }
    }
    
    
    
    return _memberView;
}


//


-(UIView *)layoutTime
{
    _timeView = [[UIView alloc]init];
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = @"剩余";
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [_timeView addSubview:_timeLabel];
    
    _countDownView = [[CLCountDownView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth/2, 30)];
    _countDownView.themeColor = MasterDefaultColor;
    _countDownView.delegate = self;
    _countDownView.textColor = [UIColor darkGrayColor];
    _countDownView.textFont = [UIFont boldSystemFontOfSize:15];
    _countDownView.countDownTimeInterval = 0;
    
    [_timeView addSubview:_countDownView];
    
    
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_timeView);
        make.centerY.equalTo(_timeView.mas_centerY);
        
    }];
    
    
    [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_timeLabel.mas_right).offset(3);
        make.top.equalTo(_timeLabel).offset(-5);
        
    }];
    
    return _timeView;
    
}

-(void)layoutUi
{
    
    [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@20);
        
    }];
    
    [_memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_groupLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_groupLabel.mas_centerY);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@230);
        make.height.equalTo(@20);
        
    }];
    
}

-(void)setInfoDic:(NSDictionary *)infoDic

{
    _infoDic = infoDic;
    
    long long timeCut = [_infoDic[@"groupbuy_endtime"] integerValue]-[_infoDic[@"current_time"] integerValue];
    _countDownView.countDownTimeInterval = timeCut;
    
    NSArray * arr = infoDic[@"user"];
    
    for (int i = 0; i<_memberArr.count; i++) {
        
        UIImageView * image = _memberArr[i];
        
        if ( i < arr.count ) {
            
            NSDictionary * dic = arr[i];
            
            [image setImageWithURLString:dic[@"img_top"] placeholderImage:[UIImage imageNamed:@"personal层-20"]];
        }
        
        
    }
    
    
    
    
}


@end
