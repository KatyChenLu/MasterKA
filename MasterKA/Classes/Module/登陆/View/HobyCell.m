//
//  HobyCell.m
//  MasterKA
//
//  Created by 余伟 on 16/7/6.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HobyCell.h"
#import "CategoryModel.h"
#import "Masonry.h"

#define BtnW 75
#define BtnH 29
#define BtnT 15



#define BtnCount 4



@implementation HobyCell
{
    
    UIView * _bgView;
    
    UILabel * _hobyLab;
    
    NSMutableString * _hobyStr;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _bgView = [[UIView alloc]init];
        
        
        _hobyLab = [[UILabel alloc]init];
        
        _hobyLab.text = @"兴趣爱好";
        
        [self.contentView addSubview:_hobyLab];
        
        [self.contentView addSubview:_bgView];
        
    }
 
    [self setUI];
    
    return self;
}




-(void)setUI {
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.left.mas_equalTo(self.contentView);
        
        make.top.mas_equalTo(self.contentView);
        
        make.right.mas_equalTo(self.contentView);
        
        make.bottom.mas_equalTo(self.contentView);
 
    }];
    
    
    [_hobyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.left.mas_equalTo(self.contentView).offset(15);
        
        make.top.mas_equalTo(self.contentView).offset(15);
        
        make.width.mas_equalTo(75);
        
        make.height.mas_equalTo(15);
        
    }];
    
    
}



-(void)configBgViewWithArr:(NSArray *)arr

{
    
    
  
    
    
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - BtnW*BtnCount)/(BtnCount+1);
    

    
    for (int i = 0; i < arr.count; i++) {
        
        NSInteger col = i%BtnCount;
        
        CGFloat btnX =  margin + col * (margin + BtnW);
        
        NSInteger row = i/BtnCount;
    
        CGFloat btnY = BtnT + row * (BtnT + BtnH)+45;
        
      
      
        
        UIButton * hobyBtn =  [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, BtnW, BtnH)];
        
      
        
        [_bgView addSubview:hobyBtn];
        
        CategoryModel * model = arr[i];
        
        [hobyBtn setBackgroundImage:[UIImage imageNamed:@"juxingkuang"] forState:UIControlStateNormal];
        
        [hobyBtn setBackgroundImage:[UIImage imageNamed:@"juxingshi"] forState:UIControlStateSelected];
        
        [hobyBtn setTag:[model.categoryId integerValue]];
        
        [hobyBtn addTarget: self action:@selector(hobyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [hobyBtn setTitle:model.name forState:UIControlStateNormal];
        
        [hobyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [hobyBtn setTintColor:[UIColor whiteColor]];
        
        
        
        if (i == arr.count-1) {
            
            self.cellH = hobyBtn.frame.origin.y + BtnH +15;
            
        }
        
        
    
        
        
        
        
    }
    
    
    
}


-(void)setArr:(NSArray *)arr
{
    
    _arr = arr;
    
    [self configBgViewWithArr:arr];
    
    
    
}



-(void)hobyBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        
        _hobyStr = [NSMutableString string];
        
        [_hobyStr appendFormat:@"%@,",[NSString stringWithFormat:@"%ld" , sender.tag]];
        
        self.saveData(_hobyStr);
        
    }
    
   
    
}

@end
