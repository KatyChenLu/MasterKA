//
//  ShopCellView.h
//  MasterKA
//
//  Created by 余伟 on 16/8/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCourseModel.h"
#import "MajorCollectionView.h"
@interface ShopCellView : UIView

@property(nonatomic ,strong)SubCourseModel* model;

@property(nonatomic ,strong) UIImageView * _majorView;

@property(nonatomic ,strong)MajorCollectionView * _majorCollectionView;

@end
