//
//  GuessLikeCell.m
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GuessLikeCell.h"
#import "GuessLikeCollectionCell.h"
#import "GoodDetailViewController.h"
#import "GoodDetailModel.h"
@interface GuessLikeCell()<UICollectionViewDataSource,UICollectionViewDelegate>




@end
@implementation GuessLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.GuessLikeView.dataSource = self;
//    NSLog(@"%@",_dataSource);ui
    self.GuessLikeView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(167, 220);
    flowLayout.minimumInteritemSpacing = 8.0f;
    self.GuessLikeView.bounces = NO;
    self.GuessLikeView.scrollEnabled = NO;
   
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.GuessLikeView setCollectionViewLayout:flowLayout];
      [self.GuessLikeView registerCellWithReuseIdentifier:@"GuessLikeCollectionCell"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark --

- (NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)setDataItems:(NSArray*)data
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:data];
    [self.GuessLikeView reloadData];
}


#pragma mark --  UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GuessLikeCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"GuessLikeCollectionCell" forIndexPath:indexPath];
    [cell showGuessLike:_dataSource[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.courseCommand) {
        [self.courseCommand execute:self.dataSource[indexPath.row]];
    }
}

@end
