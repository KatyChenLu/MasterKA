//
//  KASearchTableView.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KASearchTableView : UITableView

@property (nonatomic, strong) NSMutableArray *kaHomeData;

@property (nonatomic, strong)BaseViewController * baseVC;

@property(nonatomic ,assign)BOOL isChange;

@end
