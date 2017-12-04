//
//  HobyCollectionViewCell.m
//  MasterKA
//
//  Created by 余伟 on 16/12/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HobyCollectionViewCell.h"
#import "UserHobyBtn.h"


@implementation HobyCollectionViewCell
{
    UIImageView * _imgView;
    UILabel     * _hobyNameLabel;
    UILabel     * _discriptionLabel;
    UserHobyBtn * _addBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame]) {
        _imgView = [[UIImageView alloc]init];
        _imgView.cornerRadius = 5;
        _imgView.clipsToBounds = YES;
        _hobyNameLabel = [[UILabel alloc]init];
        _discriptionLabel = [[UILabel alloc]init];
        _addBtn  = [UserHobyBtn buttonWithType:UIButtonTypeCustom];
        
        
//        _imgView.image = [UIImage imageNamed:@"2.jpg"];
//        _hobyNameLabel.text = @"爱好";
        _hobyNameLabel.textAlignment = NSTextAlignmentCenter;
        _hobyNameLabel.font = [UIFont systemFontOfSize:14];
//        _discriptionLabel.text = @"xixiixixi爱好爱好xixiix";
        _discriptionLabel.font = [UIFont fontWithName:SpecialFont size:13];
        _discriptionLabel.textColor = [UIColor lightGrayColor];
        
        _discriptionLabel.textAlignment = NSTextAlignmentCenter;
        
          [_discriptionLabel setContentMode:UIViewContentModeTop];
        _discriptionLabel.numberOfLines = 0;
//         _addBtn.backgroundColor = [UIColor greenColor];
        
        [_addBtn setImage:[UIImage imageNamed:@"关注默认-"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"关注选中-"] forState:UIControlStateSelected];
        
        [_addBtn addTarget: self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_hobyNameLabel];
        [self.contentView addSubview:_discriptionLabel];
        [self.contentView addSubview:_addBtn];
    }
    
    [self layout];
    
    return self;
}


-(void)label
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    //    paraStyle.lineSpacing = 4; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    
    
    //设置字间距 NSKernAttributeName:@1.5f
//    NSDictionary *dictionary = @{NSFontAttributeName:[UIFont fontWithName:SpecialFont size:16], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//                                 };
    
// 
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:dic[@"content"]attributes:dictionary];
}

-(void)layout
{
    @weakify(self)
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@80);
    }];
    
    [_hobyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_imgView.mas_bottom).offset(5);
        make.width.equalTo(_imgView);
        make.height.equalTo(@20);
    }];
    
    [_discriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self)
       
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(_hobyNameLabel.mas_bottom).offset(5);
        make.height.equalTo(@40);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
       
        make.left.equalTo(_imgView).offset(10);
        make.right.equalTo(_imgView).offset(-10);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView);
        
    }];
    
    
}

-(void)add:(UserHobyBtn *)sender
{
  
    
    
    if (!sender.selected) {
        
//        _addBtn.backgroundColor = [UIColor yellowColor];
        
        self.model.select = YES;
        
    }else
    {
//        _addBtn.backgroundColor = [UIColor greenColor];
        self.model.select = NO;
    }
  
    sender.selected = !sender.selected;
    
    
    
    
    self.addHoby(sender);
    
}

-(void)setModel:(StartSubCategoryModel *)model
{
    _model = model;
    if (_model.select) {
        
        _addBtn.selected = YES;
    }else
    {
        _addBtn.selected = NO;
    }
    
    [_imgView setImageFadeInWithURLString:model.pic_url placeholderImage:nil];
    
    _hobyNameLabel.text = model.name;
    
    _discriptionLabel.text = model.intro;
    
    _addBtn.hoby = model;
    

    
    
}


@end
