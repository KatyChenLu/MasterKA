//
//  CategoryCollectionViewCell.h
//  MasterKA
//
//  Created by 余伟 on 16/12/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectionViewCell : UICollectionViewCell

@property(nonatomic , copy)NSString * categoryName;
@property(nonatomic , copy)void(^btnClick)();

@property(nonatomic ,strong) UIButton * categoryBtn;

@property(nonatomic ,strong)UIColor * color;




@end
