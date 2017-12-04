//
//  CourseV3CommentImagesTableViewCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/10/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "CourseV3CommentImagesTableViewCell.h"
#import "CourseV3CollectionViewCell.h"

@interface CourseV3CommentImagesTableViewCell ()
@property (nonatomic)NSInteger collectionSection;
@property (nonatomic)float collectionCellWH;

@end

@implementation CourseV3CommentImagesTableViewCell

- (void)awakeFromNib {
    self.mCollectionView.scrollEnabled = FALSE;
    self.mCollectionView.delegate = self;
    self.mCollectionView.dataSource = self;
    self.mCollectionView.backgroundColor = [UIColor clearColor];
    UINib *cellNib = [UINib nibWithNibName:@"CourseV3CollectionViewCell" bundle:nil];
    [self.mCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"CourseV3CollectionViewCell"];
    self.mCollectionViewHeight.constant =0;
    self.collectionCellWH = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    self.collectionCellWH = RatioBase6(71);
    self.collectionSection = self.imageUrls.count/3;
    if (self.imageUrls.count%3!=0) {
        self.collectionSection++;
    }
    
    self.mCollectionViewHeight.constant =self.collectionSection*(self.collectionCellWH+10);

    
    [self.mCollectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectionSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger page = self.imageUrls.count/3;
    if(section<page){
        return 3;
    }else{
        return self.imageUrls.count%3;
    }
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionCellWH, self.collectionCellWH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseV3CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseV3CollectionViewCell" forIndexPath:indexPath];
    NSInteger index = indexPath.section*3+indexPath.row;
    NSString* imageUrl=self.imageUrls[index];
    [cell.imageView setImageWithURLString:imageUrl placeholderImage:nil];
//    [cell.imageView canClickIt:TRUE];
//    cell.imageView.imageUrls = self.imageUrls;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
