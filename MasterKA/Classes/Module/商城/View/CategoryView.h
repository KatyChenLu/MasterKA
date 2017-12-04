//
//  CategoryView.h
//  shop
//
//  Created by 余伟 on 16/8/10.
//  Copyright © 2016年 余伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareRootModel.h"

@interface CategoryView : UICollectionView

@property(nonatomic ,strong)ShareRootModel * model;

@property(nonatomic, strong)NSMutableArray * sourceArr;
@property (nonatomic,strong)NSArray* tempAarry;

@property(nonatomic , strong)UIView *lineView;

@property(nonatomic ,assign)BOOL isChange;


@end
