//
//  StudentCell.m
//  MasterKA
//
//  Created by hyu on 16/5/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "StudentCell.h"
#import "StudentDetailCell.h"
#define IMGVIEW_WIDTH ([UIScreen mainScreen].bounds.size.width/9.4)
@interface StudentCell()<UICollectionViewDataSource,UICollectionViewDelegate>




@end
@implementation StudentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.studentCollection.dataSource = self;
    self.studentCollection.delegate = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(IMGVIEW_WIDTH, IMGVIEW_WIDTH);
    flowLayout.minimumInteritemSpacing = 17.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.studentCollection setCollectionViewLayout:flowLayout];
    [self.studentCollection registerCellWithReuseIdentifier:@"StudentDetailCell"];
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
    [self.studentCollection reloadData];
}


#pragma mark --  UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudentDetailCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"StudentDetailCell" forIndexPath:indexPath];
    [cell.img_top setImageWithURLString:_dataSource[indexPath.row][@"img_top"] placeholderImage:nil  ];
    cell.img_top.masksToBounds=YES;
    cell.img_top.cornerRadius=IMGVIEW_WIDTH/2;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"没错事件有了");
    if (self.goToDetail) {
        [self.goToDetail execute:self.dataSource[indexPath.row]];
    }
}

@end
