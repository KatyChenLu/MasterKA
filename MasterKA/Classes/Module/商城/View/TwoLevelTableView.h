//
//  TwoLevelTableView.h
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftTitleBtn.h"


@interface TwoLevelTableView : UITableView

@property(nonatomic ,strong)NSArray * subModel;
@property(nonatomic ,copy)void(^dismiss)(id ID);
@property(nonatomic ,copy)NSString * checkAllId;
@property(nonatomic ,strong)LeftTitleBtn * categoryBtn;
@property(nonatomic ,copy)NSString * firstLevel;
@property(nonatomic ,assign)BOOL  all;//全部分类

@end
