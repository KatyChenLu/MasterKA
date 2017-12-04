//
//  TYScrollPageTabBar.h
//  MasterKA
//
//  Created by jinghao on 16/4/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TYBasePageTabBar.h"
#import "HMSegmentedControl.h"

@interface TYScrollPageTabBar : TYBasePageTabBar
@property (nonatomic,strong,readonly)HMSegmentedControl *segmentedControl;
@end
