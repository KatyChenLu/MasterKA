//
//  ShopCellView.m
//  MasterKA
//
//  Created by 余伟 on 16/8/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ShopCellView.h"
#import "MajorCollectionView.h"
#import "UIImageView+Shop.h"

@implementation ShopCellView




-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        
        
      self._majorView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.width/75*35)];
        
//        self._majorView.image = [UIImage imageNamed:@"1.jpg"];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        
        self._majorView.userInteractionEnabled = YES;
        
        [self._majorView addGestureRecognizer:tap];
        
//
////        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        self._majorCollectionView = [[MajorCollectionView alloc]initWithFrame:CGRectMake(0, self._majorView.bounds.size.height, self.bounds.size.width, 180) collectionViewLayout:flowLayout];
        
        [self addSubview:self._majorView];
        
        [self addSubview:self._majorCollectionView];
        
//        self.backgroundColor = [UIColor lightGrayColor];
        
        
        
        
    }
    return self;
}



-(void)tapClick:(UITapGestureRecognizer *)tap {
    
    
    
    NSLog(@"%@" , tap.self.view);
  
    
    UIImageView * headImage = tap.self.view;

    [[NSNotificationCenter defaultCenter]postNotificationName:@"major" object:headImage.imageStr];

    
    
}


-(void)setModel:(SubCourseModel *)model
{
    
    _model = model;
    
    [self._majorView setImageWithURLString:model.cover placeholderImage:nil];
    
    //跳转h5的url
    self._majorView.imageStr = model.pfurl;
    
    self._majorCollectionView.courseArr = model.course_list.mutableCopy;
    
    
    [self._majorCollectionView reloadData];
    
//    if (self._majorCollectionView.courseArr == nil) {
//        
//        self._majorCollectionView.courseArr = model.course_list.mutableCopy;
//    }else
//    {
//        [self._majorCollectionView.courseArr removeAllObjects];
//     
//        
//        self._majorCollectionView.courseArr =  model.course_list.mutableCopy;
//        
//    }
//    
//    [self._majorCollectionView reloadData];
    
}



@end
