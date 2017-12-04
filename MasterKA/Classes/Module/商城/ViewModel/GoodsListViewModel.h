//
//  GoodsListViewModel.h
//  MasterKA
//
//  Created by xmy on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewModel.h"
#import "CollectionViewModel.h"

@interface GoodsListViewModel : CollectionViewModel

@property (nonatomic,strong)NSString *categoryId;

@property BOOL isCategory;

@property (nonatomic,strong) UIButton *shuaiXuanBtn;

- (void)gotoSelectOrder;

@end
