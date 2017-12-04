//
//  HotMasterCollectionViewCell.m
//  MasterKA
//
//  Created by lijiachao on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HotMasterCollectionViewCell.h"
#import "Masonry.h"
#import "HostManShareModel.h"
#import "UIImageView+Master.h"
@interface HotMasterCollectionViewCell()
{
    UILabel * titleLabel;
    UILabel * smallTitle;

    HostManShareModel* manlist;
    UIView* backView;
    
}
@end

@implementation HotMasterCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        backView = [[UIView alloc]init];
        backView.backgroundColor =[UIColor whiteColor];
        backView.layer.cornerRadius = 4;
        backView.layer.masksToBounds = YES;
        backView.layer.borderWidth = 0.6;
        backView.layer.borderColor = [RGBFromHexadecimal(0xe0e0e0) CGColor];
        [self.contentView addSubview:backView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.contentView);
        }];
        
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [backView addSubview:titleLabel];
        
        smallTitle = [[UILabel alloc]init];
        
        smallTitle.textAlignment =NSTextAlignmentCenter;
        smallTitle.textColor = RGBFromHexadecimal(0x999999);
        smallTitle.font = [UIFont systemFontOfSize:12];
        [backView addSubview:smallTitle];
        
        self.btn1 = [[UIImageView alloc]init];
       self.btn1.backgroundColor = [UIColor blueColor];
        // [btn1 addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
        self.btn1.userInteractionEnabled = YES;
        [self.btn1 setCanBrowser:YES];
        [backView addSubview: self.btn1];
//        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)];
        self.btn1.layer.cornerRadius = 4;
  
        self.btn1.layer.masksToBounds = YES;
        [self.btn1 setCanBrowser:YES];
        //[btn1 addGestureRecognizer:singleTap];
        
        self.btn2 = [[UIImageView alloc]init];
        self.btn2.backgroundColor = [UIColor greenColor];
       [self.btn2 setCanBrowser:YES];
        self.btn2.userInteractionEnabled = YES;
        
        self.btn2.layer.cornerRadius = 4;
        self.btn2.layer.masksToBounds = YES;
        
        [backView addSubview: self.btn2];
        
        self.btn3 = [[UIImageView alloc]init];
        self.btn3.backgroundColor = [UIColor greenColor];
        self.btn3.userInteractionEnabled = YES;
        self.btn3.layer.cornerRadius = 4;
        self.btn3.layer.masksToBounds = YES;
        [self.btn3 setCanBrowser:YES];
        [backView addSubview: self.btn3];
        
        [self.btn1 setCanBrowser:YES];
        [self.btn2 setCanBrowser:YES];
        [self.btn3 setCanBrowser:YES];
        [self layOutUI];
    }
    return self;
}

-(void) setHotMasterCollCellData:(HostManShareModel*)list{
    if(list!=nil){
        manlist = list;
        NSLog(@"%@",list);
        titleLabel.text = manlist.intro;
        smallTitle.text = manlist.nikename;
        [self.btn1 setImageFadeInWithURLString:manlist.first_photo placeholderImage:nil];
        
        [self.btn2 setImageFadeInWithURLString:manlist.second_photo placeholderImage:nil];
        [self.btn3 setImageFadeInWithURLString:manlist.third_photo placeholderImage:nil];       }
}

-(void)layOutUI{
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).with.offset(15);
        make.height.mas_equalTo(@20);
        make.right.left.equalTo(backView);
    }];
    
    [smallTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(4);
        make.height.mas_equalTo(@15);
        make.right.left.equalTo(backView);
    }];
    
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(smallTitle.mas_bottom).with.offset(8);
        make.height.width.mas_equalTo(@72.6);
        make.left.equalTo(backView).with.offset(8);
    }];
    
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(smallTitle.mas_bottom).with.offset(8);
        make.height.width.mas_equalTo(@72.6);
        make.left.equalTo(self.btn1.mas_right).with.offset(8);
    }];
    
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(smallTitle.mas_bottom).with.offset(8);
        make.height.width.mas_equalTo(@72.6);
        make.left.equalTo(self.btn2.mas_right).with.offset(8);
    }];
}

@end
