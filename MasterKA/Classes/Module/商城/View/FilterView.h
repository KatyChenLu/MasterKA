//
//  FilterView.h
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoLevelTableView.h"
#import "FirstLevelTableView.h"



@interface FilterView : UIView

@property(nonatomic ,strong)NSArray * model;

@property(nonatomic , copy)void(^filter)(id ID);

@property(nonatomic ,strong)FirstLevelTableView * firstCategoryView;

@property(nonatomic ,strong)TwoLevelTableView * twoCategoryView;


@end
