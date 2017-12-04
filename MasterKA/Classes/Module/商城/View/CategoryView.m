//
//  CategoryView.m
//  shop
//
//  Created by 余伟 on 16/8/10.
//  Copyright © 2016年 余伟. All rights reserved.
//


#define ReuseIdentifier @"CategoryViewCell"

#import "CategoryView.h"
#import "CategoryCollectionCell.h"
#import "MasterCategoryModel.h"
#import "Masonry.h"
#import "ShopBaseViewController.h"

//分类collctionView
@interface CategoryView ()<UICollectionViewDataSource , UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,ShopBaseViewControllerDlegate>




@end


@implementation CategoryView


{
    
    UICollectionViewFlowLayout * _flowLayout;
    
    
}



-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        
       _lineView  = [[UIView alloc]init];
        
        _lineView.backgroundColor = MasterDefaultColor;
        
         _lineView.frame = CGRectMake(5, 30, 25, 1.5);
        [self addSubview:_lineView];
        
        
//        layout.itemSize = CGSizeMake(60, 30);
       self.contentInset = UIEdgeInsetsMake(0, 13, 0, 13);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[CategoryCollectionCell class] forCellWithReuseIdentifier:ReuseIdentifier];
        
        self.delegate = self ;
        
        self.dataSource = self;


    }
    
    
    return self;
}




-(void)layoutSubviews
{
    
    [super layoutSubviews];
    

   
    
    
    
}



-(void)setModel:(ShareRootModel *)model
{
    

    
    _model = model;
    
    if (_isChange) {
        
        [_sourceArr removeAllObjects];
        
        self.isChange = NO;
        
    }
    
    
    if (_sourceArr.count == 0) {
        
        _sourceArr = model.category_list.mutableCopy;
        
    }else{
        
        [_sourceArr addObjectsFromArray:model.category_list];
        
        
        
        
        
    }
    
  
    
}



-(CGSize)getItemSizeWithLabeText:(NSString *)name {
    
    UILabel * label = [[UILabel alloc]init];
    
    label.text = name;
    
    label.font = [UIFont systemFontOfSize:18];
    
    [label sizeToFit];
    
    
    return label.bounds.size;
    
    
    
}


#pragma UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        MasterCategoryModel * model = self.sourceArr[indexPath.item];
    
    
    
        return [self getItemSizeWithLabeText:model.name];
}





#pragma UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return self.sourceArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    CategoryCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    
    MasterCategoryModel * model = self.sourceArr[indexPath.item];
    cell.model = model;
    
    
//    cell.contentView.backgroundColor = [UIColor redColor];
    

    
    return cell;
    
}



#pragma UICollectionViewDelegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0){
//    ShopHomeViewController* supController = self.superViewController;
//        [supController.shoppingBtn setUserInteractionEnabled:NO];
//        [supController.shoppingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        
    }
    else{
//        ShopHomeViewController* supController = self.superViewController;
//        [supController.shoppingBtn setUserInteractionEnabled:YES];
//        [supController.shoppingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
    }
    
     MasterCategoryModel * model = self.sourceArr[indexPath.item];
    
    NSArray* postArray = [NSArray arrayWithObjects:indexPath,model.categoryId,nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goto" object:postArray];
    
    CategoryCollectionCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//
    cell.model = model;

    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    NSLog(@"%@" , NSStringFromCGRect(cell.frame));
    
  
    [UIView animateWithDuration:0.1 animations:^{
        
        
        self.lineView.frame = CGRectMake(cell.frame.origin.x+1, 30, cell.frame.size.width-3, 1.5);
    }];
    
    
    
    
    NSLog(@"%lf", collectionView.contentOffset.x);
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MasterCategoryModel * model = self.sourceArr[indexPath.item];
    
    CategoryCollectionCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.model = model;
}


#pragma ShopBaseViewControllerDlegate

-(void)pageViewController:(UIPageViewController *)pageViewVc didChangeControllerWithIndex:(NSInteger)index
{
    
    [self collectionView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    
    
    [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    
//    MasterCategoryModel * model = self.sourceArr[index];
//    
//    CategoryCollectionCell * cell = [self cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
//    
//    cell.model = model;
    
    
    
}



@end
