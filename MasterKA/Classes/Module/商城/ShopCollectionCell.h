//
//  ShopCollectionCell.h
//  shop
//
//  Created by 余伟 on 16/8/10.
//  Copyright © 2016年 余伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopTableView.h"

@interface ShopCollectionCell : UICollectionViewCell

@property(nonatomic , strong)id model;

@property(nonatomic ,strong)ShopTableView * tableView;


@end
