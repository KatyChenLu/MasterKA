//
//  CategorySelectView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CategorySelectView.h"
#import "CategoryCollectionViewCell.h"

@interface CategorySelectView ()<UICollectionViewDelegate , UICollectionViewDataSource>

@end

@implementation CategorySelectView
{
    UIButton * _allBtn;
    UICollectionView * _categoryView;
    
    UIButton * _nextBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _allBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 7, 60, 30)];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        _allBtn .titleLabel.font = [UIFont systemFontOfSize:14];
        _allBtn.borderWidth = 0.3;
        _allBtn.cornerRadius = 15;
        _allBtn.borderColor = [UIColor lightGrayColor];
        [_allBtn setTitleColor:MasterDefaultColor forState:UIControlStateNormal];
        
        [_allBtn addTarget:self action:@selector(all:) forControlEvents:UIControlEventTouchUpInside];
        
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
        
        flow.itemSize = CGSizeMake(60, 44);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _categoryView = [[UICollectionView alloc]initWithFrame:CGRectMake(80, 0, ScreenWidth-80, 44) collectionViewLayout:flow];
        [_categoryView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"category"];
        
        _categoryView.showsHorizontalScrollIndicator = NO;
        _categoryView.delegate = self;
        _categoryView.dataSource = self;
        _categoryView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_allBtn];
        [self addSubview:_categoryView];
        
    }
    return self;
}


-(void)setCategorys:(NSArray *)categorys
{
    _categorys = categorys;


}

-(void)all:(UIButton *)sender
{
    [_nextBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [sender setTitleColor:MasterDefaultColor forState:UIControlStateNormal];
    
    self.filter(nil);
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    
    return self.categorys.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CategoryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"category" forIndexPath:indexPath];
    
    NSDictionary * dic = self.categorys[indexPath.row];
    
    NSString * colorStr = dic[@"color"];

    UIColor * bg = [UIColor colorWithHexString:[NSString stringWithFormat:@"#%@",colorStr]];
    
    cell.color = bg;
    cell.categoryName = dic[@"name"];
    
//    cell.contentView.backgroundColor = [UIColor redColor];
    
    
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.categorys[indexPath.row];
    /*
     {
     id = 1;
     intro = "";
     name = "\U6d3b\U52a8";
     "pic_url" = "uploadfile/2016/1213/20161213034508501_thumb.jpg";
     "sub_category_list" =     (
     {
     id = 2;
     intro = "\U6d3b\U52a8\U6d3b\U52a8";
     name = "\U6d3b\U52a8";
     "pic_url" = "uploadfile/2016/1213/20161213034531397_thumb.jpg";
     pid = 1;
     }
     );
     }

     */
    
    [_allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    CategoryCollectionViewCell * cell = (CategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
     [cell.categoryBtn setTitleColor:MasterDefaultColor forState:UIControlStateNormal];
    
    _nextBtn = cell.categoryBtn;
    
    self.filter(dic[@"id"]);
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollectionViewCell * cell = (CategoryCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell.categoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
}



@end
