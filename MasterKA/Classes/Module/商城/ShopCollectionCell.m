//
//  ShopCollectionCell.m
//  shop
//
//  Created by 余伟 on 16/8/10.
//  Copyright © 2016年 余伟. All rights reserved.
//



#import "ShopCollectionCell.h"
#import "ShopTableView.h"

@interface ShopCollectionCell () 

@end

@implementation ShopCollectionCell



-(instancetype)initWithFrame:(CGRect)frame
{
    
    
    if ( self = [super initWithFrame: frame]) {
        
        
        self.tableView = [[ShopTableView alloc]initWithFrame:self.contentView.bounds];
        
//        self.tableView.model = self.model;
        
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 110)];
//        
//        self.tableView.tableFooterView = view;
        
        
        [self.contentView addSubview:self.tableView];
        
    
        
        
    }
    
    return  self;
    
    
}


-(void)setModel:(id)model
{
    
    _model = model;
    
    self.tableView.model = model;
    
}





@end
