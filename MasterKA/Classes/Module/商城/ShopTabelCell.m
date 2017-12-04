//
//  ShopTabelCell.m
//  shop
//
//  Created by 余伟 on 16/8/10.
//  Copyright © 2016年 余伟. All rights reserved.
//

#import "ShopTabelCell.h"
#import "Masonry.h"
#import "ShopCellView.h"


@implementation ShopTabelCell
{
    
    ShopCellView * _shopCellView;
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        

        _shopCellView = [[ShopCellView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 380)];
        
        
        [self.contentView addSubview:_shopCellView];
        
    }
    

    
    return  self;
}



-(void)setModel:(SubCourseModel *)model
{
    _model = model;
    
    _shopCellView.model = self.model;
    
}








@end
