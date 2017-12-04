//
//  HobyView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HobyView.h"
#import "HobyCollectionReusableHeaderView.h"
#import "HobyCollectionViewCell.h"
#import "StartSubCategoryModel.h"
#import "UserHobyBtn.h"

@interface HobyView ()<UICollectionViewDelegate , UICollectionViewDataSource>

@end

@implementation HobyView


-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    
    if ( self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout*)layout;
        
        flowLayout.itemSize                 = CGSizeMake(100, 170);
        flowLayout.minimumLineSpacing       = 10;
        flowLayout.minimumInteritemSpacing  = 10;
//        flowLayout.headerReferenceSize      = CGSizeMake(self.width, 80);
//        flowLayout.footerReferenceSize      = CGSizeMake(self.width, 100);
        
        self. showsVerticalScrollIndicator  = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset                   = UIEdgeInsetsMake(15, 15, 15, 15);
        [self registerClass:[HobyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
//        [self registerClass:[HobyCollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//        
//        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        
        
    }
    
    return self;
}



-(void)setModel:(NSArray *)model
{
    _model = model;
    
    [self reloadData];
}


#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    StartSubCategoryModel * model = self.model[indexPath.row];
    
    HobyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = model;
    
    
    [cell setAddHoby:^(UserHobyBtn* sender){
           
        self.selectbtnEnable(sender);
    }];
    
    
//    cell.contentView.backgroundColor = [UIColor redColor];
    
    
    return cell;
    
}

#pragma UICollectionViewDelegate

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView * reusableView = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    }
//    if (kind == UICollectionElementKindSectionFooter) {
//        
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
//    }
//    
//    return  reusableView;
//}







@end
