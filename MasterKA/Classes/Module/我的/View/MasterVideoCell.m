//
//  MasterVideoCell.m
//  MasterKA
//
//  Created by hyu on 16/5/24.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterVideoCell.h"
#import "MasterVideoCollectionCell.h"
@implementation MasterVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(ScreenWidth-26, 257);
    flowLayout.minimumInteritemSpacing = 13.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.MasterVideo setCollectionViewLayout:flowLayout];
    self.MasterVideo.pagingEnabled=YES;
    [self.MasterVideo registerCellWithReuseIdentifier:@"MasterVideoCollectionCell"];
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
    if(self.dataSource.count>1){
        self.pageControl.numberOfPages = self.dataSource.count;
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.hidden=YES;
        self.collectionToPage.priority=250;
        self.collectionToBottom.priority=750;
    }
    [self.MasterVideo reloadData];
}


#pragma mark --  UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MasterVideoCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"MasterVideoCollectionCell" forIndexPath:indexPath];
    [cell showVideo:self.dataSource[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
@end
