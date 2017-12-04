
//
//  CategoryCollectionCell.m
//  MasterKA
//
//  Created by 余伟 on 16/8/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CategoryCollectionCell.h"


@interface CategoryCollectionCell ()





@end


@implementation CategoryCollectionCell





-(instancetype)initWithFrame:(CGRect)frame
{
    
    
    if (self = [super initWithFrame:frame]) {
        
    _categoryLabel = [[UILabel alloc]init];
        
        _categoryLabel.textAlignment = NSTextAlignmentCenter;

        
        [self.contentView addSubview:_categoryLabel];
    }
    
    
    return self;
}




-(void)setModel:(MasterCategoryModel *)model
{
    
    _model = model;
    
    if ([_model.name isEqualToString:@"专题"]) {
        
        _model.name = @"全部";
    }
    
    

        
    _categoryLabel.textColor = [UIColor lightGrayColor];

    
    
    _categoryLabel.text = _model.name;
    
    
    
    _categoryLabel.font = [UIFont systemFontOfSize:13];
    [_categoryLabel sizeToFit];
    _categoryLabel.frame = CGRectMake((self.bounds.size.width -_categoryLabel.bounds.size.width)*0.5, (self.bounds.size.height-_categoryLabel.bounds.size.height)*0.5, _categoryLabel.bounds.size.width, _categoryLabel.bounds.size.height);
    
    
}



-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    
//    _categoryLabel.frame = CGRectMake(0, 0, 60, 30);
 
//    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.right.equalTo(self.contentView);
//        
//        make.top.equalTo(self.contentView);
//        
//        make.height.mas_equalTo(200);
//       
//        
//        
//    }];
    
    
    
}






@end
