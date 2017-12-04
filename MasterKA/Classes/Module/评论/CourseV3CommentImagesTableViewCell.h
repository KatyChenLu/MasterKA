//
//  CourseV3CommentImagesTableViewCell.h
//  HiGoMaster
//
//  Created by jinghao on 15/10/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CourseV3CommentImagesTableViewCell : BaseTableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak)IBOutlet UICollectionView* mCollectionView;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint* mCollectionViewHeight;
@property (nonatomic,strong)NSArray* imageUrls;
@end
