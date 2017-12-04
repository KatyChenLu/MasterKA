//
//  MajorCollectionView.m
//  MasterKA
//
//  Created by 余伟 on 16/8/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//


#define ReuseIdentifier @"GuessLikeCollectionCell"
#import "MajorCollectionView.h"
#import "GuessLikeCollectionCell.h"
#import "CourseModel.h"

@interface MajorCollectionView  ()<UICollectionViewDelegate , UICollectionViewDataSource>

@end


@implementation MajorCollectionView



-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        
        layout.itemSize = CGSizeMake(125, 170);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.showsHorizontalScrollIndicator = NO;

        layout.minimumInteritemSpacing = 5.0f;
        
        self.alwaysBounceHorizontal = YES;
      
        self.contentInset = UIEdgeInsetsMake(0, 13, 0, 13);
        
        self.backgroundColor = [UIColor whiteColor];
//        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MajorCollectionViewCell];
//        [self registerClass:[CoreseCollectionCell class] forCellWithReuseIdentifier:CoreseCollectionViewCell];
        
        [self registerNib:[UINib nibWithNibName:@"GuessLikeCollectionCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
        self.delegate = self ;
        
        self.dataSource = self;
        
//        self.pagingEnabled = YES;
//        self.bounces = NO;
        
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goFor:) name:@"goto" object:nil];
        
    }
    
    
    return self;
}



#define UICollectionViewDataSource


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return self.courseArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GuessLikeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    
    [cell showGuessLike:self.courseArr[indexPath.item]];
    
    
    return cell;
    
}



#define UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    CourseModel * model = self.courseArr[indexPath.item];
    //跳转课程详情
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"course" object:model.course_id];

    
    
}


@end
