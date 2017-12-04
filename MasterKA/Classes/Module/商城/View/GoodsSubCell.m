//
//  GoodsSubCell.m
//  MasterKA
//
//  Created by xmy on 16/5/31.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GoodsSubCell.h"
#import "GuessLikeCollectionCell.h"
#import "GoodDetailViewController.h"
#import "GoodDetailModel.h"


@interface GoodsSubCell()<UICollectionViewDataSource,UICollectionViewDelegate>




@end

@implementation GoodsSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.GuessLikeView.dataSource = self;
    self.GuessLikeView.delegate = self;
    self.GuessLikeView.contentInset = UIEdgeInsetsMake(0, 13, 0, 13);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(125, 170);
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.GuessLikeView setCollectionViewLayout:flowLayout];
    [self.GuessLikeView registerCellWithReuseIdentifier:@"GuessLikeCollectionCell"];
//    self.GuessLikeView.alwaysBounceVertical = YES;
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


//// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"1");
//}
//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
//     NSLog(@"2");
//}
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//     NSLog(@"3");
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//     NSLog(@"4");
//}// called on finger up as we are moving
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"5");
//}
//    // called when scroll view grinds to a halt
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    NSLog(@"6");
//} // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2){
//     NSLog(@"7");
//} // called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
//    NSLog(@"8");
//} // scale between minimum and maximum. called after any 'bounce' animations
//
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
//    NSLog(@"9");
//}




@end
