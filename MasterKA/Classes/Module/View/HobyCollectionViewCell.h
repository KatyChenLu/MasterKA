//
//  HobyCollectionViewCell.h
//  MasterKA
//
//  Created by 余伟 on 16/12/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartSubCategoryModel.h"

@interface HobyCollectionViewCell : UICollectionViewCell

@property(nonatomic ,copy)void(^addHoby)(id hoby);//添加爱好

@property(nonatomic ,strong)StartSubCategoryModel * model;



@end
