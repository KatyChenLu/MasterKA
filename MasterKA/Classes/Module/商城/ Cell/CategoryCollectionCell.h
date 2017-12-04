//
//  CategoryCollectionCell.h
//  MasterKA
//
//  Created by 余伟 on 16/8/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterCategoryModel.h"

@interface CategoryCollectionCell : UICollectionViewCell


@property(nonatomic, strong)UILabel * categoryLabel;

@property(nonatomic ,strong)MasterCategoryModel * model;


@end
