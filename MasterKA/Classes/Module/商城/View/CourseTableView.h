//
//  CourseTableView.h
//  MasterKA
//
//  Created by 余伟 on 16/8/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseListModel.h"

@interface CourseTableView : UITableView

@property(nonatomic ,strong)CourseListModel * model;

@property(nonatomic ,strong)NSMutableArray * courseArr;

@property(nonatomic ,assign)BOOL isChange;

-(void)first;

@end
